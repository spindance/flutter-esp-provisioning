package com.spindance.esp_provisioning

import android.annotation.SuppressLint
import android.content.Context
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import com.espressif.provisioning.DeviceConnectionEvent
import com.espressif.provisioning.ESPConstants
import com.espressif.provisioning.ESPDevice
import com.espressif.provisioning.ESPProvisionManager
import com.google.gson.Gson

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import java.lang.IllegalStateException

/// Android implementation of the ESP Provisioning Plugin.
class EspProvisioningPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private var context: Context? = null

  private val provisioningManager by lazy { ESPProvisionManager.getInstance(context) }
  private var scannedDevices = mapOf<String, ScannedPeripheral>()
  private var connectionResultCallback: Result? = null

  init {
    EventBus.getDefault().register(this)
  }

  /// FlutterPlugin override.
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, PLUGIN_NAME)
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  /// FlutterPlugin override.
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    context = null
  }

  /// MethodCallHandler override; processes incoming MethodChannel calls.
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull resultCallback: Result) {
    Log.d(TAG, "onMethodCall ${call.method}")

    when (call.method) {
      SCAN_BLE_DEVICES -> {
        val devicePrefix: String? = call.arguments()
        scan(devicePrefix, resultCallback)
      }
      STOP_BLE_DEVICE_SCAN -> {
        stopScan(resultCallback)
      }
      CONNECT -> {
        val arguments: HashMap<String, String>? = call.arguments()
        val deviceName: String? = arguments?.get(DEVICE_NAME)
        val serviceUuid: String? = arguments?.get(SERVICE_UUID)
        val pop: String? = arguments?.get(PROOF_OF_POSSESSION)

        if (deviceName == null || serviceUuid == null || pop == null) {
          resultCallback.reportBadArgs(CONNECT)
          return
        }

        connect(deviceName, pop, serviceUuid, resultCallback)
      }
      DISCONNECT -> {
        val deviceName: String? = call.arguments()

        if (deviceName == null) {
          resultCallback.reportBadArgs(DISCONNECT)
          return
        }

        disconnect(deviceName, resultCallback)
      }
      GET_ACCESS_POINTS -> {
        val deviceName: String? = call.arguments()

        if (deviceName == null) {
          resultCallback.reportBadArgs(GET_ACCESS_POINTS)
          return
        }

        getAccessPoints(deviceName, resultCallback)
      }
      SET_ACCESS_POINT -> {
        val arguments: HashMap<String, String>? = call.arguments()
        val deviceName: String? = arguments?.get(DEVICE_NAME)
        val ssid: String? = arguments?.get(SSID)
        val password: String? = arguments?.get(PASSWORD)

        if (deviceName == null || ssid == null || password == null) {
          resultCallback.reportBadArgs(SET_ACCESS_POINT)
          return
        }

        setAccessPoint(deviceName, ssid, password, resultCallback)
      }
      SEND_DATA -> {
        val arguments: HashMap<String, String>? = call.arguments()
        val deviceName: String? = arguments?.get(DEVICE_NAME)
        val endpointPath: String? = arguments?.get(ENDPOINT_PATH)
        val base64Data: String? = arguments?.get(BASE64_DATA)

        if (deviceName == null || endpointPath == null || base64Data == null) {
          resultCallback.reportBadArgs(SEND_DATA)
          return
        }

        sendData(deviceName, endpointPath, base64Data, resultCallback)
      }
      else -> {
        resultCallback.notImplemented()
      }
    }
  }

  /// Processes BLE scan requests.
  @SuppressLint("MissingPermission")
  private fun scan(devicePrefix: String?, resultCallback: Result) {
    Log.d(TAG, "Scanning for devices with name prefix '${devicePrefix}'")
    scannedDevices = emptyMap()
    connectionResultCallback = null

    provisioningManager.searchBleEspDevices(
      devicePrefix ?: "",
      SdkBleScanListener() { scanResult ->
        scanResult.fold(
          onFailure = { resultCallback.logErrorAndFail(it) },
          onSuccess = { deviceMap ->
            scannedDevices = deviceMap

            // Convert the deviceMap to a list of EspBleDevice converted to JSON strings.
            val devices = deviceMap.values.map { EspBleDevice(it.device.name, it.scanResult.rssi)}.toList()
            val devicesJson = devices.map { Gson().toJson(it).toString() }
            resultCallback.success(devicesJson)
          }
        )
      }
    )
  }

  /// Processes stop BLE scan requests.
  @SuppressLint("MissingPermission")
  private fun stopScan(resultCallback: Result) {
    Log.d(TAG, "Stopping Scan...")

    try {
      provisioningManager.stopBleScan()
    } catch (e: IllegalStateException) {
      // The Espressif library throws when there has previously been a successful stopBleScan call
      // and then stopBleScan is called again when there is no ongoing scan taking place. We'll just
      // ignore this error because it's harmless.
      Log.d(TAG, "Ignoring exception in stopScan: ${e.toString()}")
    }

    Log.d(TAG, "Scan stopped")
    resultCallback.success(null);
  }

  /// Processes BLE connect requests.
  @SuppressLint("MissingPermission")
  private fun connect(
    deviceName: String,
    proofOfPossession: String,
    provisioningServiceUuid: String,
    resultCallback: Result
  ) {
    findScannedDevice(deviceName, resultCallback)?.let { scannedDevice ->
      connectionResultCallback = resultCallback

      val espDevice = provisioningManager.createESPDevice(
        SdkEspConstants.ESP_TRANSPORT,
        SdkEspConstants.ESP_SECURITY
      )
      espDevice.deviceName = deviceName
      espDevice.proofOfPossession = proofOfPossession
      espDevice.primaryServiceUuid = provisioningServiceUuid
      espDevice.bluetoothDevice = scannedDevice.device
      espDevice.connectToDevice()
    }
  }

  /// /// Processes BLE disconnect requests.
  @SuppressLint("MissingPermission")
  private fun disconnect(deviceName: String, resultCallback: Result) {
    findEspDevice(deviceName, resultCallback)?.let {
      // Upon the disconnect() call we'll only get an event bus callback for
      // ESPConstants.EVENT_DEVICE_DISCONNECTED if already connected, therefore to keep things
      // simple, we will not track pending disconnection requests nor track whether we are connected
      // or not. Also, note that the ESP lib does not report any disconnection errors in the event
      // bus callback. I.e., the disconnect call always succeeds when there is a connection, and it
      // always simply returns when there is no connection (it cannot fail).
      connectionResultCallback = null
      it.disconnectDevice()
      resultCallback.success(null)
    }
  }

  /// Processes get access points requests.
  private fun getAccessPoints(deviceName: String, resultCallback: Result) {
    findEspDevice(deviceName, resultCallback)?.let { device ->
      device.scanNetworks(ScanNetworksListener { result ->
        result.fold(
          onFailure = { resultCallback.logErrorAndFail(it) },
          onSuccess = { apList -> resultCallback.success(apList.map { Gson().toJson(it).toString() }) }
        )
      })
    }
  }

  /// Processes setAccessPoint requests.
  private fun setAccessPoint(deviceName: String, ssid: String, passPhrase: String, resultCallback: Result) {
    findEspDevice(deviceName, resultCallback)?.let { device ->
      device.provision(ssid, passPhrase, SdkProvisionListener { result ->
        result.fold(
          onFailure = { resultCallback.logErrorAndFail(it) },
          onSuccess = { resultCallback.success(null) }
        )
      })
    }
  }

  /// Processes sendData requests (write data to custom BLE endpoint).
  private fun sendData(deviceName: String, path: String, base64Data: String, resultCallback: Result) {
    findEspDevice(deviceName, resultCallback)?.let { device ->
      val dataBytes = Base64.decode(base64Data, Base64.DEFAULT)
      device.sendDataToCustomEndPoint(path, dataBytes, SendDataListener { result ->
        result.fold(
          onFailure = { resultCallback.logErrorAndFail(it) },
          onSuccess = { resultCallback.success(String(Base64.encode(it, Base64.DEFAULT))) }
        )
      })
    }
  }

  /// EventBus event handler; used to detect BLE connection events reported by the ESP library.
  @Subscribe(threadMode = ThreadMode.MAIN)
  public fun onEvent(event: DeviceConnectionEvent) {
    Log.d(TAG, "Got event: ${event.eventType}")

    when (event.eventType) {
      ESPConstants.EVENT_DEVICE_CONNECTED ->
        connectionResultCallback?.let {
          it.success(null)
        } ?: Log.e(TAG, "Got EVENT_DEVICE_CONNECTED but connectionPromise is null")

      ESPConstants.EVENT_DEVICE_CONNECTION_FAILED ->
        connectionResultCallback?.let {
          it.logErrorAndFail(EspException.DeviceConnectionFailed)
        } ?: Log.e(TAG, "Got EVENT_DEVICE_CONNECTION_FAILED but connectionPromise is null")

      ESPConstants.EVENT_DEVICE_DISCONNECTED ->
        connectionResultCallback?.let {
          // This would be where connect was called, but an unexpected disconnect occurred.
          it.logErrorAndFail(EspException.UnexpectedDeviceDisconnection)
        } ?: Log.d(TAG, "Ignoring ESPConstants.EVENT_DEVICE_DISCONNECTED")
    }

    // All the above events should be "terminal" states, so we can clear connectionPromise here.
    connectionResultCallback = null
  }

  /// Finds the ScannedPeripheral with deviceName in our local cache of BLE scanned results.
  @SuppressLint("MissingPermission")
  private fun findScannedDevice(deviceName: String, resultCallback: Result): ScannedPeripheral? {
    val scannedDevice = scannedDevices.values.firstOrNull { it.device.name == deviceName }

    return if (scannedDevice == null) {
      resultCallback.logErrorAndFail(EspException.ScannedDeviceNotFound)
      null
    } else {
      scannedDevice
    }
  }

  /// Utilizes findScannedDevice to find a cached scan result, then utilizes the ESP provisioning
  /// manager to get its current ESPDevice, ensuring the two match.
  private fun findEspDevice(deviceName: String, resultCallback: Result): ESPDevice? {
    findScannedDevice(deviceName, resultCallback)?.let { scannedDevice ->
      provisioningManager.espDevice?.let { espDevice ->
        if (scannedDevice.device.address == espDevice.bluetoothDevice.address) {
          return espDevice
        }
      }

      resultCallback.logErrorAndFail(EspException.EspDeviceNotFound)
    }
    return null
  }

  companion object {
    private const val TAG = "EspProvisioningPlugin"
    private const val PLUGIN_NAME = "esp_provisioning_android"
    private const val SCAN_BLE_DEVICES = "scanBleDevices"
    private const val STOP_BLE_DEVICE_SCAN = "stopBleDeviceScan"
    private const val CONNECT = "connect"
    private const val DISCONNECT = "disconnect"
    private const val GET_ACCESS_POINTS = "getAccessPoints"
    private const val SET_ACCESS_POINT = "setAccessPoint"
    private const val SEND_DATA = "sendData"
    private const val DEVICE_NAME = "deviceName"
    private const val SERVICE_UUID = "provisioningServiceUuid"
    private const val PROOF_OF_POSSESSION = "proofOfPossession"
    private const val SSID = "ssid"
    private const val PASSWORD = "password"
    private const val ENDPOINT_PATH = "endpointPath"
    private const val BASE64_DATA = "base64Data"

    private fun Result.logErrorAndFail(error: Throwable) {
      Log.e(TAG, "Error: $error")
      val errorCodeString = if (error is EspException) error.errorCodeString else error.toString()
      error(errorCodeString, null, null)
    }

    private fun Result.reportBadArgs(methodName: String) =
      logErrorAndFail(EspException.InvalidMethodChannelArguments(methodName))
  }
}
