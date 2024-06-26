/// Wi-Fi access point security modes, as defined by Espressif.
enum EspWifiAccessPointSecurity {
  /// Open security.
  open(value: 0),

  /// WEP security.
  wep(value: 1),

  /// WPA-PSK security.
  wpaPsk(value: 2),

  /// WPA2-PSK security.
  wpa2Psk(value: 3),

  /// WPA/WPA2-PSK security.
  wpaWpa2Psk(value: 4),

  /// WPA2-Enterprise security.
  wpa2Enterprise(value: 5),

  /// Unknown security.
  unknown(value: 6);

  const EspWifiAccessPointSecurity({required this.value});

  factory EspWifiAccessPointSecurity.fromValue(int value) => values.firstWhere((element) => element.value == value);

  /// The integer value of the security mode.
  final int value;
}
