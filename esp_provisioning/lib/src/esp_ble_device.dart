import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'esp_ble_device.g.dart';
part 'esp_ble_device.freezed.dart';

/// Represents an ESP32 device.
@freezed
class EspBleDevice with _$EspBleDevice {
  /// Creates a new instance of [EspBleDevice].time.
  const factory EspBleDevice({
    /// The device's advertised name.
    required String name,
    /// The device's BLE RSSI.
    required int rssi,
  }) = _EspBleDevice;

  /// Creates a new instance of [EspBleDevice] from a JSON object.
  factory EspBleDevice.fromJson(Map<String, dynamic> json) => _$EspBleDeviceFromJson(json);
}
