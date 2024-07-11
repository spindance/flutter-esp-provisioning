// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'esp_ble_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EspBleDevice _$EspBleDeviceFromJson(Map<String, dynamic> json) {
  return _EspBleDevice.fromJson(json);
}

/// @nodoc
mixin _$EspBleDevice {
  /// The device's advertised name.
  String get name => throw _privateConstructorUsedError;

  /// The device's BLE RSSI. The Espressif iOS library does not provide this value; on iOS it will always be 0.
  int get rssi => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EspBleDeviceCopyWith<EspBleDevice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EspBleDeviceCopyWith<$Res> {
  factory $EspBleDeviceCopyWith(EspBleDevice value, $Res Function(EspBleDevice) then) =
      _$EspBleDeviceCopyWithImpl<$Res, EspBleDevice>;
  @useResult
  $Res call({String name, int rssi});
}

/// @nodoc
class _$EspBleDeviceCopyWithImpl<$Res, $Val extends EspBleDevice> implements $EspBleDeviceCopyWith<$Res> {
  _$EspBleDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? rssi = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rssi: null == rssi
          ? _value.rssi
          : rssi // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EspBleDeviceImplCopyWith<$Res> implements $EspBleDeviceCopyWith<$Res> {
  factory _$$EspBleDeviceImplCopyWith(_$EspBleDeviceImpl value, $Res Function(_$EspBleDeviceImpl) then) =
      __$$EspBleDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int rssi});
}

/// @nodoc
class __$$EspBleDeviceImplCopyWithImpl<$Res> extends _$EspBleDeviceCopyWithImpl<$Res, _$EspBleDeviceImpl>
    implements _$$EspBleDeviceImplCopyWith<$Res> {
  __$$EspBleDeviceImplCopyWithImpl(_$EspBleDeviceImpl _value, $Res Function(_$EspBleDeviceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? rssi = null,
  }) {
    return _then(_$EspBleDeviceImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rssi: null == rssi
          ? _value.rssi
          : rssi // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EspBleDeviceImpl with DiagnosticableTreeMixin implements _EspBleDevice {
  const _$EspBleDeviceImpl({required this.name, required this.rssi});

  factory _$EspBleDeviceImpl.fromJson(Map<String, dynamic> json) => _$$EspBleDeviceImplFromJson(json);

  /// The device's advertised name.
  @override
  final String name;

  /// The device's BLE RSSI. The Espressif iOS library does not provide this value; on iOS it will always be 0.
  @override
  final int rssi;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EspBleDevice(name: $name, rssi: $rssi)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'EspBleDevice'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('rssi', rssi));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EspBleDeviceImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rssi, rssi) || other.rssi == rssi));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, rssi);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EspBleDeviceImplCopyWith<_$EspBleDeviceImpl> get copyWith =>
      __$$EspBleDeviceImplCopyWithImpl<_$EspBleDeviceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EspBleDeviceImplToJson(
      this,
    );
  }
}

abstract class _EspBleDevice implements EspBleDevice {
  const factory _EspBleDevice({required final String name, required final int rssi}) = _$EspBleDeviceImpl;

  factory _EspBleDevice.fromJson(Map<String, dynamic> json) = _$EspBleDeviceImpl.fromJson;

  @override

  /// The device's advertised name.
  String get name;
  @override

  /// The device's BLE RSSI. The Espressif iOS library does not provide this value; on iOS it will always be 0.
  int get rssi;
  @override
  @JsonKey(ignore: true)
  _$$EspBleDeviceImplCopyWith<_$EspBleDeviceImpl> get copyWith => throw _privateConstructorUsedError;
}
