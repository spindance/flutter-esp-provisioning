package com.spindance.esp_provisioning

import android.bluetooth.BluetoothDevice
import android.bluetooth.le.ScanRecord
import android.bluetooth.le.ScanResult

data class ScannedPeripheral(
  val device: BluetoothDevice,
  val scanResult: ScanResult,
  val scanRecord: ScanRecord
)
