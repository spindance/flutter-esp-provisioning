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
    case .open: stringValue = PluginConstants.WifiSecurityNames.open
    case .wep: stringValue = PluginConstants.WifiSecurityNames.wep
    case .wpaPsk: stringValue = PluginConstants.WifiSecurityNames.wpaPsk
    case .wpa2Psk: stringValue = PluginConstants.WifiSecurityNames.wpa2psk
    case .wpaWpa2Psk: stringValue = PluginConstants.WifiSecurityNames.wpaWpa2Psk
    case .wpa2Enterprise: stringValue = PluginConstants.WifiSecurityNames.wpa2Enterprise
    case .unknown: stringValue = PluginConstants.WifiSecurityNames.unknown
    }

    try container.encode(stringValue)
  }
}
