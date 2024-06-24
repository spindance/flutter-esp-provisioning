import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'src/esp_ble_device.dart';

class _MethodNames {
  static const scanBleDevices = 'scanBleDevices';
  static const stopBleDeviceScan = 'stopBleDeviceScan';
}

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
    final devices = await methodChannel.invokeListMethod<String>(_MethodNames.scanBleDevices, deviceNamePrefix);
    if (devices == null) throw Exception('Unable to scan for devices.');
    return devices.cast<String>();
  }

  /// Stops an ongoing scan for devices.
  Future<void> stopEspDeviceScan() => methodChannel.invokeMethod<void>(_MethodNames.stopBleDeviceScan);
}