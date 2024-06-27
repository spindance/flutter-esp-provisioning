/// Constants used in the ESP Provisioning Plugin's Dart, Android and iOS implementations.
enum PluginConstants {
  static let pluginName = "esp_provisioning_ios"

  enum MethodNames {
    static let scanBleDevices = "scanBleDevices"
    static let stopBleDeviceScan = "stopBleDeviceScan"
    static let connect = "connect"
    static let disconnect = "disconnect"
    static let getAccessPoints = "getAccessPoints"
    static let setAccessPoint = "setAccessPoint"
    static let sendData = "sendData"
  }

  enum ArgumentNames {
    static let deviceName = "deviceName"
    static let serviceUuid = "provisioningServiceUuid"
    static let proofOfPossession = "proofOfPossession"
    static let ssid = "ssid"
    static let password = "password"
    static let endpointPath = "endpointPath"
    static let base64DataString = "base64Data"
  }

  enum WifiSecurityNames {
    static let open = "OPEN"
    static let wep = "WEP"
    static let wpaPsk = "WPA_PSK"
    static let wpa2psk = "WPA2PSK"
    static let wpaWpa2Psk = "WPA_WPA2_PSK"
    static let wpa2Enterprise = "WPA2_ENTERPRISE"
    static let unknown = "UNKNOWN"
  }
}
