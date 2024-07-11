import ESPProvision
import Foundation

/// External representation of ESPDevice
struct EspBleDevice: Codable, Equatable {
  let name: String
  let rssi: Int

  init(espDevice: ESPDevice) {
    name = espDevice.name

    // The Espressif iOS library does not make peripheral RSSI public, so we use 0.
    rssi = 0
  }
}
