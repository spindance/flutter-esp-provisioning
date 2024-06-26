import 'esp_wifi_access_point_security.dart';

/// Represents a Wi-Fi access point as reported by an ESP device.
class EspWifiAccessPoint {
  /// Creates a new instance of [EspWifiAccessPoint].
  EspWifiAccessPoint({required this.ssid, required this.channel, required this.security, required this.rssi});

  /// Creates a new instance of [EspWifiAccessPoint] from a map.
  EspWifiAccessPoint.fromMap(Map<String, dynamic> map)
      : ssid = map['ssid'] as String,
        channel = map['channel'] as int,
        security = EspWifiAccessPointSecurity.values[map['security'] as int],
        rssi = map['rssi'] as int;

  /// The SSID of the access point.
  final String ssid;

  /// The channel of the access point. On Android, this value is always 0.
  final int channel;

  /// The security configuration of the access point.
  final EspWifiAccessPointSecurity security;

  /// The signal strength of the access point.
  final int rssi;
}
