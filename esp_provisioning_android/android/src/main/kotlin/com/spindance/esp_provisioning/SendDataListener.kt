package com.spindance.esp_provisioning

import android.util.Log
import com.espressif.provisioning.listeners.ResponseListener
import kotlin.Exception

class SendDataListener(
  private val completionCallback: (Result<ByteArray>) -> Unit
): ResponseListener {
  override fun onSuccess(returnData: ByteArray?) {
    if (returnData == null) {
      fail(EspException.Unexpected("Return data is null"))
    } else {
      completionCallback(Result.success(returnData))
    }
  }

  override fun onFailure(e: Exception?) {
    fail(e ?: EspException.Unexpected("Send Data error (null)"))
  }

  private fun fail(error: Throwable) {
    Log.e(TAG, error.toString())
    completionCallback(Result.failure(error))
  }

  companion object {
    const val TAG = "SendDataListener"
  }
}
