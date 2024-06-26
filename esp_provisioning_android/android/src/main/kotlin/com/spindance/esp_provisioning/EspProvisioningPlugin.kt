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

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import java.lang.IllegalStateException

/// Convenience extension on Result that simply logs an error and invokes this.error() with the specified errorCodeString.
fun Result.logErrorAndFail(tag: String, error: Throwable) {
  Log.e(tag, "Error: $error")
  val errorCodeString = if (error is EspException) error.errorCodeString else error.toString()
  error(errorCodeString, null, null)
}

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
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "esp_provisioning_android")
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
      "scanBleDevices" -> {
        val devicePrefix: String? = call.arguments()
        scan(devicePrefix, resultCallback)
      }
      "stopBleDeviceScan" -> {
        stopScan(resultCallback)
      }
      "connect" -> {
        val arguments: HashMap<String, String>? = call.arguments()
        val deviceName: String? = arguments?.get("deviceName")
        val serviceUuid: String? = arguments?.get("provisioningServiceUuid")
        val pop: String? = arguments?.get("proofOfPossession")

        if (deviceName == null || serviceUuid == null || pop == null) {
          resultCallback.logErrorAndFail(TAG, EspException.InvalidMethodChannelArguments("connect"))
          return
        }

        connect(deviceName, pop, serviceUuid, resultCallback)
      }
      "disconnect" -> {
        val deviceName: String? = call.arguments()

        if (deviceName == null) {
          resultCallback.logErrorAndFail(TAG, EspException.InvalidMethodChannelArguments("disconnect"))
          return
        }

        disconnect(deviceName, resultCallback)
      }
      "getAccessPoints" -> {
        val deviceName: String? = call.arguments()

        if (deviceName == null) {
          resultCallback.logErrorAndFail(TAG, EspException.InvalidMethodChannelArguments("getAccessPoints"))
          return
        }

        getAccessPoints(deviceName, resultCallback)
      }
      "setAccessPoint" -> {
        val arguments: HashMap<String, String>? = call.arguments()
        val deviceName: String? = arguments?.get("deviceName")
        val ssid: String? = arguments?.get("ssid")
        val password: String? = arguments?.get("password")

        if (deviceName == null || ssid == null || password == null) {
          resultCallback.logErrorAndFail(TAG, EspException.InvalidMethodChannelArguments("setAccessPoints"))
          return
        }

        setAccessPoint(deviceName, ssid, password, resultCallback)
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
          onFailure = { resultCallback.logErrorAndFail(TAG, it) },
          onSuccess = { deviceMap ->
            scannedDevices = deviceMap
            resultCallback.success(deviceMap.values.map { it.device.name })
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
      val listener = ScanNetworksListener { result ->
        result.fold(
          onFailure = { resultCallback.logErrorAndFail(TAG, it) },
          onSuccess = {
            val ssids = it.map { accessPoint -> accessPoint.ssid }
            Log.d(TAG, ssids.toString())
            resultCallback.success(ssids)
          }
        )
      }
      device.scanNetworks(listener)
    }
  }

  /// Processes setAccessPoint requests.
  private fun setAccessPoint(deviceName: String, ssid: String, passPhrase: String, resultCallback: Result) {
    findEspDevice(deviceName, resultCallback)?.let { device ->
      device.provision(ssid, passPhrase, SdkProvisionListener { result ->
        result.fold(
          onFailure = { resultCallback.logErrorAndFail(TAG, it) },
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
          onFailure = { resultCallback.logErrorAndFail(TAG, it) },
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
          it.logErrorAndFail(TAG, EspException.DeviceConnectionFailed)
        } ?: Log.e(TAG, "Got EVENT_DEVICE_CONNECTION_FAILED but connectionPromise is null")

      ESPConstants.EVENT_DEVICE_DISCONNECTED ->
        connectionResultCallback?.let {
          // This would be where connect was called, but an unexpected disconnect occurred.
          it.logErrorAndFail(TAG, EspException.UnexpectedDeviceDisconnection)
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
      resultCallback.logErrorAndFail(TAG, EspException.ScannedDeviceNotFound)
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

      resultCallback.logErrorAndFail(TAG, EspException.EspDeviceNotFound)
    }
    return null
  }

  companion object {
    const val TAG = "EspProvisioningPlugin"
  }
}
