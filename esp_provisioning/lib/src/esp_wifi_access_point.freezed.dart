// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'esp_wifi_access_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EspWifiAccessPoint _$EspWifiAccessPointFromJson(Map<String, dynamic> json) {
  return _EspWifiAccessPoint.fromJson(json);
}

/// @nodoc
mixin _$EspWifiAccessPoint {
  /// The SSID of the access point.
  String get ssid => throw _privateConstructorUsedError;

  /// The channel of the access point. On Android, channel is unsupported so the value is always 0.
  int get channel => throw _privateConstructorUsedError;

  /// The security configuration of the access point.
  EspWifiAccessPointSecurity get security => throw _privateConstructorUsedError;

  /// The Wi-Fi signal strength of the access point.
  int get rssi => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EspWifiAccessPointCopyWith<EspWifiAccessPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EspWifiAccessPointCopyWith<$Res> {
  factory $EspWifiAccessPointCopyWith(
          EspWifiAccessPoint value, $Res Function(EspWifiAccessPoint) then) =
      _$EspWifiAccessPointCopyWithImpl<$Res, EspWifiAccessPoint>;
  @useResult
  $Res call(
      {String ssid,
      int channel,
      EspWifiAccessPointSecurity security,
      int rssi});
}

/// @nodoc
class _$EspWifiAccessPointCopyWithImpl<$Res, $Val extends EspWifiAccessPoint>
    implements $EspWifiAccessPointCopyWith<$Res> {
  _$EspWifiAccessPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ssid = null,
    Object? channel = null,
    Object? security = null,
    Object? rssi = null,
  }) {
    return _then(_value.copyWith(
      ssid: null == ssid
          ? _value.ssid
          : ssid // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as int,
      security: null == security
          ? _value.security
          : security // ignore: cast_nullable_to_non_nullable
              as EspWifiAccessPointSecurity,
      rssi: null == rssi
          ? _value.rssi
          : rssi // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EspWifiAccessPointImplCopyWith<$Res>
    implements $EspWifiAccessPointCopyWith<$Res> {
  factory _$$EspWifiAccessPointImplCopyWith(_$EspWifiAccessPointImpl value,
          $Res Function(_$EspWifiAccessPointImpl) then) =
      __$$EspWifiAccessPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ssid,
      int channel,
      EspWifiAccessPointSecurity security,
      int rssi});
}

/// @nodoc
class __$$EspWifiAccessPointImplCopyWithImpl<$Res>
    extends _$EspWifiAccessPointCopyWithImpl<$Res, _$EspWifiAccessPointImpl>
    implements _$$EspWifiAccessPointImplCopyWith<$Res> {
  __$$EspWifiAccessPointImplCopyWithImpl(_$EspWifiAccessPointImpl _value,
      $Res Function(_$EspWifiAccessPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ssid = null,
    Object? channel = null,
    Object? security = null,
    Object? rssi = null,
  }) {
    return _then(_$EspWifiAccessPointImpl(
      ssid: null == ssid
          ? _value.ssid
          : ssid // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as int,
      security: null == security
          ? _value.security
          : security // ignore: cast_nullable_to_non_nullable
              as EspWifiAccessPointSecurity,
      rssi: null == rssi
          ? _value.rssi
          : rssi // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EspWifiAccessPointImpl
    with DiagnosticableTreeMixin
    implements _EspWifiAccessPoint {
  _$EspWifiAccessPointImpl(
      {required this.ssid,
      required this.channel,
      required this.security,
      required this.rssi});

  factory _$EspWifiAccessPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$EspWifiAccessPointImplFromJson(json);

  /// The SSID of the access point.
  @override
  final String ssid;

  /// The channel of the access point. On Android, channel is unsupported so the value is always 0.
  @override
  final int channel;

  /// The security configuration of the access point.
  @override
  final EspWifiAccessPointSecurity security;

  /// The Wi-Fi signal strength of the access point.
  @override
  final int rssi;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EspWifiAccessPoint(ssid: $ssid, channel: $channel, security: $security, rssi: $rssi)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'EspWifiAccessPoint'))
      ..add(DiagnosticsProperty('ssid', ssid))
      ..add(DiagnosticsProperty('channel', channel))
      ..add(DiagnosticsProperty('security', security))
      ..add(DiagnosticsProperty('rssi', rssi));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EspWifiAccessPointImpl &&
            (identical(other.ssid, ssid) || other.ssid == ssid) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.security, security) ||
                other.security == security) &&
            (identical(other.rssi, rssi) || other.rssi == rssi));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ssid, channel, security, rssi);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EspWifiAccessPointImplCopyWith<_$EspWifiAccessPointImpl> get copyWith =>
      __$$EspWifiAccessPointImplCopyWithImpl<_$EspWifiAccessPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EspWifiAccessPointImplToJson(
      this,
    );
  }
}

abstract class _EspWifiAccessPoint implements EspWifiAccessPoint {
  factory _EspWifiAccessPoint(
      {required final String ssid,
      required final int channel,
      required final EspWifiAccessPointSecurity security,
      required final int rssi}) = _$EspWifiAccessPointImpl;

  factory _EspWifiAccessPoint.fromJson(Map<String, dynamic> json) =
      _$EspWifiAccessPointImpl.fromJson;

  @override

  /// The SSID of the access point.
  String get ssid;
  @override

  /// The channel of the access point. On Android, channel is unsupported so the value is always 0.
  int get channel;
  @override

  /// The security configuration of the access point.
  EspWifiAccessPointSecurity get security;
  @override

  /// The Wi-Fi signal strength of the access point.
  int get rssi;
  @override
  @JsonKey(ignore: true)
  _$$EspWifiAccessPointImplCopyWith<_$EspWifiAccessPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
