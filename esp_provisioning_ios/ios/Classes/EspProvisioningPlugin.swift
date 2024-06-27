import ESPProvision
import Flutter
import UIKit

private enum Constants {
  static let pluginName = "esp_provisioning_ios"
  static let scanBleDevices = "scanBleDevices"
  static let stopBleDeviceScan = "stopBleDeviceScan"
  static let connect = "connect"
  static let disconnect = "disconnect"
  static let getAccessPoints = "getAccessPoints"
  static let setAccessPoint = "setAccessPoint"
  static let sendData = "sendData"
  static let deviceName = "deviceName"
  static let serviceUuid = "provisioningServiceUuid"
  static let proofOfPossession = "proofOfPossession"
  static let ssid = "ssid"
  static let password = "password"
  static let endpointPath = "endpointPath"
  static let base64DataString = "base64Data"
}

public class EspProvisioningPlugin: NSObject, FlutterPlugin {
  /// We  only support "security 1" devices.
  private static let security = ESPSecurity.secure

  /// We only support BLE transport (not Wi-Fi)
  private static let transport = ESPTransport.ble

  private let provisioningManager = ESPProvisionManager.shared

  private var scannedDevices = [ESPDevice]()

  /// Dictionary of device name to proof of possession string
  private var proofOfPossessionMap = [String: String]()

  /// The ESP library holds onto the completion block passed to searchEspDevices, such that, for example, if the function is called and then stopEspDeviceSearch is
  /// called, and the stopEspDeviceSearch is called again, the searchEspDevices completion block will be called on the second call to stopEspDeviceSearch.
  private var scanInProgress = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: Constants.pluginName, binaryMessenger: registrar.messenger())
    let instance = EspProvisioningPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let badInputsError = EspPluginError.invalidMethodChannelInputs(call.method)

    switch call.method {
    case Constants.scanBleDevices:
      searchEspDevices(devicePrefix: call.arguments as? String ?? "", resultCallback: result)
    case Constants.stopBleDeviceScan:
      stopEspDeviceSearch(result)
    case Constants.connect:
      guard 
        let dictionary = call.arguments as? Dictionary<String, String>,
        let deviceName = dictionary[Constants.deviceName],
        let pop = dictionary[Constants.proofOfPossession] 
      else {
        Utilities.reportFailure(with: badInputsError, resultCallback: result)
        return
      }
      
      connect(deviceName: deviceName, proofOfPossession: pop, resultCallback: result)
    case Constants.disconnect:
      guard let deviceName = call.arguments as? String else {
        Utilities.reportFailure(with: badInputsError, resultCallback: result)
        return
      }

      disconnect(deviceName: deviceName, resultCallback: result)
    case Constants.getAccessPoints:
      guard let deviceName = call.arguments as? String else {
        Utilities.reportFailure(with: badInputsError, resultCallback: result)
        return
      }

      scanWifiList(deviceName: deviceName, resultCallback: result)
    case Constants.setAccessPoint:
      guard
        let dictionary = call.arguments as? Dictionary<String, String>,
        let deviceName = dictionary[Constants.deviceName],
        let ssid = dictionary[Constants.ssid],
        let password = dictionary[Constants.password]
      else {
        Utilities.reportFailure(with: badInputsError, resultCallback: result)
        return
      }

      provision(deviceName: deviceName, ssid: ssid, passPhrase: password, resultCallback: result)
    case Constants.sendData:
      guard
        let dictionary = call.arguments as? Dictionary<String, String>,
        let deviceName = dictionary[Constants.deviceName],
        let endpointPath = dictionary[Constants.endpointPath],
        let dataString = dictionary[Constants.base64DataString]
      else {
        Utilities.reportFailure(with: badInputsError, resultCallback: result)
        return
      }

      sendData(deviceName: deviceName, path: endpointPath, dataString: dataString, resultCallback: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func searchEspDevices(devicePrefix: String, resultCallback: @escaping FlutterResult) {
    scannedDevices = []
    scanInProgress = true

    provisioningManager.searchESPDevices(
      devicePrefix: devicePrefix,
      transport: Self.transport,
      security: Self.security
    ) { [weak self] devices, error in
      self?.scanInProgress = false

      guard error == nil else {
        if case .espDeviceNotFound = error {
          // Don't treat this as an error, just return an empty array.
          resultCallback([EspBleDevice]())
        } else {
          Utilities.reportFailure(with: error!, resultCallback: resultCallback)
        }

        return
      }

      guard let discoveredDevices = devices else {
        let error = EspPluginError.unexpectedError("devices and error are both nil")
        Utilities.reportFailure(with: error, resultCallback: resultCallback)
        return
      }

      self?.scannedDevices = discoveredDevices

      do {
        let devices = try discoveredDevices.map { try EspBleDevice(espDevice: $0).asJsonString() }
        resultCallback(devices)
      } catch {
        Utilities.reportFailure(with: error, resultCallback: resultCallback)
      }
    }
  }

  func stopEspDeviceSearch(_ resultCallback: @escaping FlutterResult) {
    if scanInProgress {
      provisioningManager.stopESPDevicesSearch()
      scanInProgress = false
    }

    resultCallback(nil)
  }

  func connect(deviceName: String, proofOfPossession: String, resultCallback: @escaping FlutterResult) {
    guard let device = find(deviceNamed: deviceName, resultCallback: resultCallback) else { return }

    Utilities.log(message: "Connecting to \(deviceName) with PoP '\(proofOfPossession)'")

    proofOfPossessionMap[deviceName] = proofOfPossession

    // Todo: Shouldn't need to set this, because the delegate is presumably being set in the call
    // below, but without this the connect appeared not to work. Need to confirm...
    device.delegate = self

    device.connect(delegate: self) { status in
      switch status {
      case .connected:
        Utilities.log(message: "Connected to \(deviceName)")
        resultCallback(nil)
      case .disconnected:
        Utilities.reportFailure(
          with: EspPluginError.unexpectedError("connect() returned disconnected"),
          resultCallback: resultCallback
        )
      case .failedToConnect(let error):
        Utilities.reportFailure(with: error, resultCallback: resultCallback)
      }
    }
  }

  func disconnect(deviceName: String, resultCallback: @escaping FlutterResult) {
    guard let device = find(deviceNamed: deviceName, resultCallback: resultCallback) else { return }

    Utilities.log(message: "Disconnecting from \(deviceName)")

    device.disconnect()
    proofOfPossessionMap.removeValue(forKey: deviceName)
    resultCallback(nil)
  }

  func scanWifiList(deviceName: String, resultCallback: @escaping FlutterResult) {
    guard let device = find(deviceNamed: deviceName, resultCallback: resultCallback) else { return }

    Utilities.log(message: "Getting access points from \(deviceName)")

    device.scanWifiList { networks, error in
      guard error == nil else {
        Utilities.reportFailure(with: error!, resultCallback: resultCallback, message: "scanWifiList() failed")
        return
      }

      guard let networks = networks else {
        Utilities.reportFailure(
          with: EspPluginError.unexpectedError("error and networks are both nil"),
          resultCallback: resultCallback
        )
        return
      }

      Utilities.log(message: "got access points: \(networks.map{ $0.ssid }.joined(separator: ", "))")

      do {
        let accessPointStrings = try networks.map {
          AccessPoint(
            ssid: $0.ssid,
            channel: UInt($0.channel),
            security: AccessPointSecurity(rawValue: $0.auth.rawValue) ?? AccessPointSecurity.unknown,
            rssi: Int($0.rssi)
          )
        }.map { try $0.asJsonString() }
        resultCallback(accessPointStrings)
      } catch {
        Utilities.reportFailure(with: error, resultCallback: resultCallback)
      }
    }
  }

  func provision(
    deviceName: String,
    ssid: String,
    passPhrase: String,
    resultCallback: @escaping FlutterResult
  ) {
    Utilities.log(message: "Provisioning access point: \(ssid)")

    guard let device = find(deviceNamed: deviceName, resultCallback: resultCallback) else { return }

    device.provision(ssid: ssid, passPhrase: passPhrase) { status in
      switch status {
      case .success:
        Utilities.log(message: "Connected to network: \(ssid)")
        resultCallback(nil)
      case .failure(let error):
        Utilities.reportFailure(with: error, resultCallback: resultCallback, message: "Failure to connect to network: \(ssid)")
      case .configApplied:
        Utilities.log(message: "\(status)")
      }
    }
  }

  func sendData(
    deviceName: String,
    path: String,
    dataString: String,
    resultCallback: @escaping FlutterResult
  ) {
    Utilities.log(message: "Sending data to endpoint '\(path)': \(dataString)")

    guard let byteArray = Data(base64Encoded: dataString) else {
      let error = EspPluginError.unexpectedError("decode() sendData failed")
      Utilities.reportFailure(with: error, resultCallback: resultCallback)
      return
    }

    guard let device = find(deviceNamed: deviceName, resultCallback: resultCallback) else { return }

    device.sendData(path: path, data: byteArray) { data, error in
      guard error == nil else {
        Utilities.reportFailure(with: error!, resultCallback: resultCallback, message: "sendData() failed")
        return
      }

      guard let data = data else {
        Utilities.reportFailure(
          with: EspPluginError.unexpectedError("error and data are both nil"),
          resultCallback: resultCallback
        )
        return
      }

      resultCallback(data.base64EncodedString())
    }
  }

  private func find(deviceNamed name: String, resultCallback: @escaping FlutterResult) -> ESPDevice? {
    guard let device = scannedDevices.first(where: { $0.name == name }) else {
      Utilities.reportFailure(with: EspPluginError.deviceNotFound, resultCallback: resultCallback)
      return nil
    }

    return device
  }
}

extension EspProvisioningPlugin: ESPDeviceConnectionDelegate {
  public func getProofOfPossesion(forDevice: ESPDevice, completionHandler: @escaping (String) -> Void) {
    let proofOfPossession = proofOfPossessionMap[forDevice.name]

    if proofOfPossession == nil {
      Utilities.printError(EspPluginError.unexpectedError("No proof of possession found for \(forDevice.name)"))
    }

    Utilities.log(message: "Using PoP '\(proofOfPossession ?? "<empty>") for \(forDevice.name)")
    completionHandler(proofOfPossession ?? "")
  }

  public func getUsername(forDevice: ESPDevice, completionHandler: @escaping (String?) -> Void) {
    // username is only needed for ESP security2. We're using security1, so return nil.
    completionHandler(nil)
  }
}

