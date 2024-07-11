import Foundation

struct AccessPoint: Codable, Equatable {
  let ssid: String
  let channel: UInt
  let security: AccessPointSecurity
  let rssi: Int
}
