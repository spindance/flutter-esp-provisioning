package com.spindance.esp_provisioning.model

enum class AccessPointSecurity(val value: Int) {
  OPEN(0),
  WEP(1),
  WPA_PSK(2),
  WPA2PSK(3),
  WPA_WPA2_PSK(4),
  WPA2_ENTERPRISE(5),
  UNKNOWN(6);

  companion object {
    fun fromValue(value: Int) =
      AccessPointSecurity.values().firstOrNull { it.value == value} ?: UNKNOWN
  }
}
