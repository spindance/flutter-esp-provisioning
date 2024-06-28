import 'plugin_wifi_security_names.dart';

/// Wi-Fi access point security modes, as defined by Espressif.
enum EspWifiAccessPointSecurity {
  /// Open security.
  open(value: PluginWifiSecurityNames.open),

  /// WEP security.
  wep(value: PluginWifiSecurityNames.wep),

  /// WPA-PSK security.
  wpaPsk(value: PluginWifiSecurityNames.wpaPsk),

  /// WPA2-PSK security.
  wpa2Psk(value: PluginWifiSecurityNames.wpa2psk),

  /// WPA/WPA2-PSK security.
  wpaWpa2Psk(value: PluginWifiSecurityNames.wpaWpa2Psk),

  /// WPA2-Enterprise security.
  wpa2Enterprise(value: PluginWifiSecurityNames.wpa2Enterprise),

  /// Unknown security.
  unknown(value: PluginWifiSecurityNames.unknown);

  const EspWifiAccessPointSecurity({required this.value});

  factory EspWifiAccessPointSecurity.fromJson(String value) => values.firstWhere((element) => element.value == value);

  /// The String value of the security mode.
  final String value;
}
