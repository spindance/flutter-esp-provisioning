import Foundation

enum AccessPointSecurity: Int, Codable {
  case open = 0
  case wep = 1
  case wpaPsk = 2
  case wpa2Psk = 3
  case wpaWpa2Psk = 4
  case wpa2Enterprise = 5
  case unknown = 6

  func encode(to encoder: Encoder) throws {
    let stringValue: String
    var container = encoder.singleValueContainer()

    switch self {
    case .open: stringValue = "OPEN"
    case .wep: stringValue = "WEP"
    case .wpaPsk: stringValue = "WPA_PSK"
    case .wpa2Psk: stringValue = "WPA2PSK"
    case .wpaWpa2Psk: stringValue = "WPA_WPA2_PSK"
    case .wpa2Enterprise: stringValue = "WPA2_ENTERPRISE"
    case .unknown: stringValue = "UNKNOWN"
    }

    try container.encode(stringValue)
  }
}
