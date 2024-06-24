package com.spindance.esp_provisioning

sealed class EspIdfProvisioningException(message: String) : Exception(message) {
  object ScanStartFailed: EspIdfProvisioningException("ScanStartFailed")
  object ScannedDeviceNotFound: EspIdfProvisioningException("ScannedDeviceNotFound")
  object EspDeviceNotFound: EspIdfProvisioningException("EspDeviceNotFound")
  object DeviceConnectionFailed: EspIdfProvisioningException("DeviceConnectionFailed")
  object UnexpectedDeviceDisconnection: EspIdfProvisioningException("UnexpectedDeviceDisconnection")
  object WifiProvisioningUuidNotSet: EspIdfProvisioningException("WifiProvisioningUuidNotSet")
  object WifiScanFailed: EspIdfProvisioningException("WifiScanFailed")
  class ProvisioningFailed(reason: String): EspIdfProvisioningException("ProvisioningFailed: $reason")
  class Unexpected(description: String): EspIdfProvisioningException("Unexpected: $description")
}
