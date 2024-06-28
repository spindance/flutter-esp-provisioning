import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'plugin_argument_names.dart';
import 'plugin_method_names.dart';

/// The interface that implementations of esp_provisioning must implement.
///
/// Platform implementations should extend this class rather than implement it as `EspProvisioning`. Extending this
/// class (using `extends`) ensures that the subclass will get the default implementation, while platform
/// implementations that `implements` this interface will be broken by newly added [EspProvisioningPlatform] methods.
abstract class EspProvisioningPlatform extends PlatformInterface {
  /// Constructs a EspProvisioningPlatform.
  EspProvisioningPlatform() : super(token: _token);

  static final Object _token = Object();

  static late EspProvisioningPlatform _instance;

  /// The default instance of [EspProvisioningPlatform] to use.
  static EspProvisioningPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific class that extends
  /// [EspProvisioningPlatform] when they register themselves.
  static set instance(EspProvisioningPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// The name of the method channel used to communicate with the native platform. For examples, 'esp_provisioning_ios'
  /// and 'esp_provisioning_android'; extending classes must override.
  String get methodChannelName;

  /// The name of the platform, e.g., "Android", 'iOS"; extending classes must override.
  String get platformName;

  /// The method channel used to communicate with the native platform.
  late final methodChannel = MethodChannel(methodChannelName);

  /// Scans for and returns a list of devices whose name starts with [deviceNamePrefix]. If [deviceNamePrefix] is null,
  /// all devices found in the scan are returned.
  Future<List<String>> scanForEspDevices(String? deviceNamePrefix) async {
    final devices = await methodChannel.invokeListMethod<String>(
        PluginMethodNames.scanBleDevices, deviceNamePrefix);
    if (devices == null) throw Exception('Unable to scan for devices.');
    return devices.cast<String>();
  }

  /// Stops an ongoing scan for devices.
  Future<void> stopEspDeviceScan() =>
      methodChannel.invokeMethod<void>(PluginMethodNames.stopBleDeviceScan);

  /// Connect to the ESP device with the specified [deviceName] using the optional [proofOfPossession] and the specified
  /// [provisioningServiceUuid].
  Future<void> connectDevice(String deviceName, String provisioningServiceUuid,
          String? proofOfPossession) =>
      methodChannel
          .invokeMethod<void>(PluginMethodNames.connect, <String, dynamic>{
        PluginArgumentNames.deviceName: deviceName,
        PluginArgumentNames.provisioningServiceUuid: provisioningServiceUuid,
        PluginArgumentNames.proofOfPossession: proofOfPossession ?? '',
      });

  /// Disconnect from the ESP device with the specified [deviceName].
  Future<void> disconnectDevice(String deviceName) => methodChannel
      .invokeMethod<void>(PluginMethodNames.disconnect, deviceName);

  /// Get the list of access points available to the ESP device with the specified [deviceName].
  Future<List<String>> getEspAccessPoints(String deviceName) async {
    final accessPoints = await methodChannel.invokeListMethod<String>(
        PluginMethodNames.getAccessPoints, deviceName);
    if (accessPoints == null) throw Exception('Unable to get access points.');
    return accessPoints.cast<String>();
  }

  /// Set the access point on the ESP device with the specified [deviceName] to the specified [ssid] and [password].
  Future<void> setEspAccessPoint(
          String deviceName, String ssid, String password) =>
      methodChannel.invokeMethod<void>(
          PluginMethodNames.setAccessPoint, <String, dynamic>{
        PluginArgumentNames.deviceName: deviceName,
        PluginArgumentNames.ssid: ssid,
        PluginArgumentNames.password: password,
      });

  /// Send Base64 encoded data to the ESP device with the specified [deviceName] using the custom BLE endpoint indicated
  /// by [endpointPath].
  Future<String> sendData(
      String deviceName, String endpointPath, String base64Data) async {
    final base64StringResult = await methodChannel
        .invokeMethod<String>(PluginMethodNames.sendData, <String, dynamic>{
      PluginArgumentNames.deviceName: deviceName,
      PluginArgumentNames.endpointPath: endpointPath,
      PluginArgumentNames.base64Data: base64Data,
    });
    if (base64StringResult == null) throw Exception('Unable to send data.');
    return base64StringResult;
  }
}
