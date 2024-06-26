package com.spindance.esp_provisioning

import android.annotation.SuppressLint
import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanResult
import android.util.Log
import com.espressif.provisioning.listeners.BleScanListener

class SdkBleScanListener(
  private val completionCallback: (Result<Map<String, ScannedPeripheral>>) -> Unit
): BleScanListener {
  private var devices = mutableMapOf<String, ScannedPeripheral>()

  override fun scanCompleted() {
    Log.d(EspProvisioningPlugin.TAG,"Found ${devices.values.size} device(s)")
    completionCallback(Result.success(devices.toMap()))
  }

  override fun scanStartFailed() = fail(EspException.ScanStartFailed)

  @SuppressLint("MissingPermission")
  override fun onPeripheralFound(device: BluetoothDevice?, scanResult: ScanResult?) {
    val scanRecord = scanResult?.scanRecord

    if (device == null || scanResult == null || scanRecord == null) {
      val description = "device or scanResult or scanRecord is null"
      fail(EspException.Unexpected(description))
    } else {
      Log.d(TAG, "Got scanned device ${device.name}")
      devices[device.address] = ScannedPeripheral(device, scanResult, scanRecord)
    }
  }

  override fun onFailure(e: Exception?) = fail(e ?: EspException.Unexpected("Scan error (null)"))

  private fun fail(error: Throwable) {
    Log.e(TAG, error.toString())
    completionCallback(Result.failure(error))
  }

  companion object {
    const val TAG = "SdkBleScanListener"
  }
}
