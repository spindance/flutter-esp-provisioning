// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'esp_ble_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EspBleDeviceImpl _$$EspBleDeviceImplFromJson(Map<String, dynamic> json) =>
    _$EspBleDeviceImpl(
      name: json['name'] as String,
      rssi: (json['rssi'] as num).toInt(),
    );

Map<String, dynamic> _$$EspBleDeviceImplToJson(_$EspBleDeviceImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rssi': instance.rssi,
    };
