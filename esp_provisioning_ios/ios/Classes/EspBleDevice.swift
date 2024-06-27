import ESPProvision
import Foundation

/// External representation of ESPDevice
struct EspBleDevice: Codable, Equatable {
  let name: String
  let rssi: Int

  init(espDevice: ESPDevice) {
    name = espDevice.name
    rssi = 0
  }
}
