package com.spindance.esp_provisioning

import com.espressif.provisioning.WiFiAccessPoint
//import kotlinx.serialization.Serializable

//@Serializable
data class AccessPoint(
  val ssid: String,
  val channel: UInt,
  val security: AccessPointSecurity,
  val rssi: Int,
) {
  constructor(espWifiAccessPoint: WiFiAccessPoint): this(
    espWifiAccessPoint.wifiName,
    0u, // ESP Android lib does not provide access point channel
    AccessPointSecurity.fromValue(espWifiAccessPoint.security),
    espWifiAccessPoint.rssi
  )

  val hashMap: HashMap<String, Any> get() {
    val map = HashMap<String, Any>()
    map["ssid"] = ssid
    map["channel"] = channel
    map["security"] = security.value
    map["rssi"] = rssi
    return map
  }
}
