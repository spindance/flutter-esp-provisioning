package com.spindance.esp_provisioning

sealed class EspException(val errorCodeString: String) : Exception(errorCodeString) {
  data object ScanStartFailed: EspException("ScanStartFailed")
  data object ScannedDeviceNotFound: EspException("ScannedDeviceNotFound")
  data object EspDeviceNotFound: EspException("EspDeviceNotFound")
  data object DeviceConnectionFailed: EspException("DeviceConnectionFailed")
  data object UnexpectedDeviceDisconnection: EspException("UnexpectedDeviceDisconnection")
  class ProvisioningFailed(reason: String): EspException("ProvisioningFailed.$reason")
  class Unexpected(description: String): EspException("Unexpected: $description")
  class InvalidMethodChannelArguments(methodName: String): EspException("InvalidMethodChannelArguments.$methodName")
}
