/// Wi-Fi access point security modes, as defined by Espressif.
enum EspWifiAccessPointSecurity {
  /// Open security.
  open(value: 'OPEN'),

  /// WEP security.
  wep(value: 'WEP'),

  /// WPA-PSK security.
  wpaPsk(value: 'WPA_PSK'),

  /// WPA2-PSK security.
  wpa2Psk(value: 'WPA2PSK'),

  /// WPA/WPA2-PSK security.
  wpaWpa2Psk(value: 'WPA_WPA2_PSK'),

  /// WPA2-Enterprise security.
  wpa2Enterprise(value: 'WPA2_ENTERPRISE'),

  /// Unknown security.
  unknown(value: 'UNKNOWN');

  const EspWifiAccessPointSecurity({required this.value});

  factory EspWifiAccessPointSecurity.fromJson(String value) => values.firstWhere((element) => element.value == value);

  /// The String value of the security mode.
  final String value;
}
