import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'esp_wifi_access_point_security.dart';

part 'esp_wifi_access_point.freezed.dart';
part 'esp_wifi_access_point.g.dart';

/// Represents a Wi-Fi access point as reported by an ESP device.
@freezed
class EspWifiAccessPoint with _$EspWifiAccessPoint {
  /// Creates a new instance of [EspWifiAccessPoint].
  const factory EspWifiAccessPoint({
    /// The SSID of the access point.
    required String ssid,

    /// The channel of the access point. On Android, channel is unsupported so the value is always 0.
    required int channel,

    /// The security configuration of the access point.
    required EspWifiAccessPointSecurity security,

    /// The Wi-Fi signal strength of the access point.
    required int rssi,
  }) = _EspWifiAccessPoint;

  /// Creates a new instance of [EspWifiAccessPoint] from a JSON object.
  factory EspWifiAccessPoint.fromJson(Map<String, dynamic> json) =>
      _$EspWifiAccessPointFromJson(json);
}
