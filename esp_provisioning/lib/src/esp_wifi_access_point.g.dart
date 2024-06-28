// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'esp_wifi_access_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EspWifiAccessPointImpl _$$EspWifiAccessPointImplFromJson(Map<String, dynamic> json) => _$EspWifiAccessPointImpl(
      ssid: json['ssid'] as String,
      channel: (json['channel'] as num).toInt(),
      security: EspWifiAccessPointSecurity.fromJson(json['security'] as String),
      rssi: (json['rssi'] as num).toInt(),
    );

Map<String, dynamic> _$$EspWifiAccessPointImplToJson(_$EspWifiAccessPointImpl instance) => <String, dynamic>{
      'ssid': instance.ssid,
      'channel': instance.channel,
      'security': _$EspWifiAccessPointSecurityEnumMap[instance.security]!,
      'rssi': instance.rssi,
    };

const _$EspWifiAccessPointSecurityEnumMap = {
  EspWifiAccessPointSecurity.open: 'open',
  EspWifiAccessPointSecurity.wep: 'wep',
  EspWifiAccessPointSecurity.wpaPsk: 'wpaPsk',
  EspWifiAccessPointSecurity.wpa2Psk: 'wpa2Psk',
  EspWifiAccessPointSecurity.wpaWpa2Psk: 'wpaWpa2Psk',
  EspWifiAccessPointSecurity.wpa2Enterprise: 'wpa2Enterprise',
  EspWifiAccessPointSecurity.unknown: 'unknown',
};
