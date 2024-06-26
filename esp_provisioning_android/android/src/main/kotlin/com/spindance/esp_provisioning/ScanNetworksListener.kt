package com.spindance.esp_provisioning

import android.util.Log
import com.espressif.provisioning.WiFiAccessPoint
import com.espressif.provisioning.listeners.WiFiScanListener
import java.lang.Exception
import java.util.ArrayList

class ScanNetworksListener(
  private val completionCallback: (Result<List<AccessPoint>>) -> Unit
): WiFiScanListener {
  override fun onWifiListReceived(wifiList: ArrayList<WiFiAccessPoint>?) {
    val list = wifiList?.toList() ?: emptyList()
    Log.d(TAG, "Found ${list.size} access points")
    completionCallback(Result.success(list.map { AccessPoint(it) }))
  }

  override fun onWiFiScanFailed(e: Exception?) {
    completionCallback(
      Result.failure(e ?: EspException.Unexpected("onWiFiScanFailed (null)"))
    )
  }

  companion object {
    const val TAG = "SdkWifiScanListener"
  }
}
