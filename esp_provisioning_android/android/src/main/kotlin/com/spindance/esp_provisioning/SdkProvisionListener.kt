package com.spindance.esp_provisioning

import android.util.Log
import com.espressif.provisioning.ESPConstants
import com.espressif.provisioning.listeners.ProvisionListener
import com.spindance.esp_provisioning.model.EspException
import kotlin.Exception

class SdkProvisionListener(
  private val completionCallback: (Result<Unit>) -> Unit
): ProvisionListener {
  override fun createSessionFailed(e: Exception?) {
    fail( "createSessionFailed", e)
  }

  override fun wifiConfigSent() {
    Log.d(TAG, "wifiConfigSent...")
  }

  override fun wifiConfigFailed(e: Exception?) {
    fail( "wifiConfigFailed", e)
  }

  override fun wifiConfigApplied() {
    Log.d(TAG, "wifiConfigApplied...")
  }

  override fun wifiConfigApplyFailed(e: Exception?) {
    fail("wifiConfigApplyFailed", e)
  }

  override fun provisioningFailedFromDevice(failureReason: ESPConstants.ProvisionFailureReason?) {
    val reasonDescription = provisioningFailureReasonDescription(failureReason)
    val exception = EspException.ProvisioningFailed(reasonDescription)
    fail("provisioningFailedFromDevice", exception)
  }

  override fun deviceProvisioningSuccess() {
    Log.d(TAG, "deviceProvisioningSuccess")
    completionCallback(Result.success(Unit))
  }

  override fun onProvisioningFailed(e: Exception?) {
    fail("onProvisioningFailed", e)
  }

  private fun fail(caller: String, e: Throwable?) {
    val error = e ?: EspException.Unexpected("null")
    Log.e(TAG, "$caller: $error")
    completionCallback(Result.failure(error))
  }

  companion object {
    const val TAG = "SdkProvisionListener"

    private fun provisioningFailureReasonDescription(reason: ESPConstants.ProvisionFailureReason?) =
      when (reason) {
        ESPConstants.ProvisionFailureReason.AUTH_FAILED -> "AUTH_FAILED"
        ESPConstants.ProvisionFailureReason.DEVICE_DISCONNECTED -> "DEVICE_DISCONNECTED"
        ESPConstants.ProvisionFailureReason.NETWORK_NOT_FOUND -> "NETWORK_NOT_FOUND"
        ESPConstants.ProvisionFailureReason.UNKNOWN -> "UNKNOWN"
        null -> "UNSPECIFIED"
      }
  }
}
