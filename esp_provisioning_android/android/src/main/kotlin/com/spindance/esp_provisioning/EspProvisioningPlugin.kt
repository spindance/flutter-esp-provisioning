package com.spindance.esp_provisioning

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull

import com.espressif.provisioning.ESPProvisionManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.IllegalStateException

class EspProvisioningPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private var context: Context? = null

  private val provisioningManager by lazy { ESPProvisionManager.getInstance(context) }
  private var scannedDevices = mapOf<String, ScannedPeripheral>()
//  private var connectionPromise: Promise? = null

//  init {
//    EventBus.getDefault().register(this)
//  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "esp_provisioning_android")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

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
      else -> {
        resultCallback.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    context = null
  }

  @SuppressLint("MissingPermission")
  fun scan(devicePrefix: String?, resultCallback: Result) {
    Log.d(TAG, "Scanning for devices with name prefix '${devicePrefix}'")
    scannedDevices = emptyMap()
//    connectionPromise = null

    provisioningManager.searchBleEspDevices(
      devicePrefix ?: "",
      SdkBleScanListener() { scanResult ->
        scanResult.fold(
          onFailure = { resultCallback.logErrorAndFail(TAG, "searchBleEspDevices failed", it) },
          onSuccess = { deviceMap ->
            scannedDevices = deviceMap
            resultCallback.success(deviceMap.values.map { it.device.name })
          }
        )
      }
    )
  }

  @SuppressLint("MissingPermission")
  fun stopScan(resultCallback: Result) {
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

//  @SuppressLint("MissingPermission")
//  fun connect(
//    deviceName: String,
//    proofOfPossession: String,
//    provisioningServiceUuid: String,
//    promise: Promise
//  ) {
//    findScannedDevice(deviceName, promise)?.let { scannedDevice ->
//      connectionPromise = promise
//
//      val espDevice = provisioningManager.createESPDevice(
//        SdkEspConstants.ESP_TRANSPORT,
//        SdkEspConstants.ESP_SECURITY
//      )
//      espDevice.deviceName = deviceName
//      espDevice.proofOfPossession = proofOfPossession
//      espDevice.primaryServiceUuid = provisioningServiceUuid
//      espDevice.bluetoothDevice = scannedDevice.device
//      espDevice.connectToDevice()
//    }
//  }
//
//  @SuppressLint("MissingPermission")
//  fun disconnect(deviceName: String,  promise: Promise) {
//    findEspDevice(deviceName, promise)?.let {
//      // Upon the disconnect() call we'll only get an event bus callback for
//      // ESPConstants.EVENT_DEVICE_DISCONNECTED if already connected, therefore to keep things
//      // simple, we will not track pending disconnection requests nor track whether we are connected
//      // or not. Also, note that the ESP lib does not report any disconnection errors in the event
//      // bus callback. I.e., the disconnect call always succeeds when there is a connection, and it
//      // always simply returns when there is no connection (it cannot fail).
//      connectionPromise = null
//      it.disconnectDevice()
//      promise.logMessageAndResolve(TAG, "Disconnected", null)
//    }
//  }
//
//  fun scanWifiList(deviceName: String, promise: Promise) {
//    findEspDevice(deviceName, promise)?.let { device ->
//      device.scanNetworks(
//        SdkWifiScanListener { result ->
//          result.fold(
//            onFailure = { promise.logErrorAndReject(TAG, null, it) },
//            onSuccess = {
//              promise.logMessageAndResolveWithIterable(TAG, "Got ${it.size} APs", it)
//            }
//          )
//        }
//      )
//    }
//  }
//
//  fun provision(deviceName: String, ssid: String, passPhrase: String, promise: Promise) {
//    findEspDevice(deviceName, promise)?.let { device ->
//      device.provision(ssid, passPhrase, SdkProvisionListener { result ->
//        result.fold(
//          onFailure = { promise.logErrorAndReject(TAG, "device.provision onFailure", it) },
//          onSuccess = { promise.logMessageAndResolve(TAG, "provision() onSuccess", null) }
//        )
//      })
//    }
//  }
//
//  fun sendData(deviceName: String, path: String, dataString: String, promise: Promise) {
//    findEspDevice(deviceName, promise)?.let { device ->
//      val dataBytes = Base64.decode(dataString, Base64.DEFAULT)
//      device.sendDataToCustomEndPoint(path, dataBytes, SdkResponseListener { result ->
//        result.fold(
//          onFailure = { promise.logErrorAndReject(TAG, "device.sendData onFailure", it) },
//          onSuccess = {
//            val data = String(Base64.encode(it, Base64.DEFAULT))
//            promise.logMessageAndResolve(TAG, "Received data over BLE", data)
//          }
//        )
//      })
//    }
//  }

//  @Subscribe(threadMode = ThreadMode.MAIN)
//  public fun onEvent(event: DeviceConnectionEvent) {
//    Log.d(TAG, "Got event: ${event.eventType}")
//
//    when (event.eventType) {
//      ESPConstants.EVENT_DEVICE_CONNECTED ->
//        connectionPromise?.let {
//          it.logMessageAndResolve(TAG, "Resolving connectionPromise", null)
//        } ?: Log.e(TAG, "Got EVENT_DEVICE_CONNECTED but connectionPromise is null")
//
//      ESPConstants.EVENT_DEVICE_CONNECTION_FAILED ->
//        connectionPromise?.let {
//          it.logErrorAndReject(
//            TAG,
//            "Rejecting connectionPromise due to $event",
//            EspIdfProvisioningException.DeviceConnectionFailed
//          )
//        } ?: Log.e(TAG, "Got EVENT_DEVICE_CONNECTION_FAILED but connectionPromise is null")
//
//      ESPConstants.EVENT_DEVICE_DISCONNECTED ->
//        connectionPromise?.let {
//          // This would be where connect was called, but an unexpected disconnect occurred.
//          it.logErrorAndReject(
//            TAG,
//            "Disconnected unexpectedly",
//            EspIdfProvisioningException.UnexpectedDeviceDisconnection
//          )
//        } ?: Log.d(TAG, "Ignoring ESPConstants.EVENT_DEVICE_DISCONNECTED")
//    }
//
//    // All the above events should be "terminal" states, so we can clear connectionPromise here.
//    connectionPromise = null
//  }

//  @SuppressLint("MissingPermission")
//  private fun findScannedDevice(deviceName: String, promise: Promise): ScannedPeripheral? {
//    val scannedDevice = scannedDevices.values.firstOrNull { it.device.name == deviceName }
//
//    return if (scannedDevice == null) {
//      promise.logErrorAndReject(
//        TAG,
//        "$deviceName not found",
//        EspIdfProvisioningException.ScannedDeviceNotFound
//      )
//      null
//    } else {
//      scannedDevice
//    }
//  }
//
//  private fun findEspDevice(deviceName: String, promise: Promise): ESPDevice? {
//    findScannedDevice(deviceName, promise)?.let { scannedDevice ->
//      provisioningManager.espDevice?.let { espDevice ->
//        if (scannedDevice.device.address == espDevice.bluetoothDevice.address) {
//          return espDevice
//        }
//      }
//    }
//
//    promise.logErrorAndReject(
//      TAG,
//      "$deviceName does not match current EspDevice",
//      EspIdfProvisioningException.EspDeviceNotFound
//    )
//    return null
//  }

  companion object {
    const val TAG = "EspProvisioningPlugin"
  }
}

/// Convenience extension on Result that simply logs an error and invokes this.error() with the specified errorCodeString.
/// All errors will be reported as predefined
fun Result.logErrorAndFail(tag: String, errorCodeString: String, error: Throwable?) {
  Log.e(tag, "Error: $errorCodeString $error")
  error(errorCodeString, null, null)
}
