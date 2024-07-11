/// Strings used to represent the security type of a Wi-Fi access point used in the Android and iOS plugins; must be
/// modified with care!
class PluginWifiSecurityNames {
  /// Open (no password) security.
  static const open = 'OPEN';

  /// WEP security.
  static const wep = 'WEP';

  /// WPA-PSK security.
  static const wpaPsk = 'WPA_PSK';

  /// WPA2-PSK security.
  static const wpa2psk = 'WPA2PSK';

  /// WPA/WPA2-PSK security.
  static const wpaWpa2Psk = 'WPA_WPA2_PSK';

  /// WPA2-Enterprise security.
  static const wpa2Enterprise = 'WPA2_ENTERPRISE';

  /// Unknown security.
  static const unknown = 'UNKNOWN';
}
