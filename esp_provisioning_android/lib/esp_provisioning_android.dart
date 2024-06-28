import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';

/// The Android implementation of [EspProvisioningPlatform].
class EspProvisioningAndroid extends EspProvisioningPlatform {
  @override
  final methodChannelName = 'esp_provisioning_android';

  @override
  final String platformName = 'Android';

  /// Registers this class as the default instance of [EspProvisioningPlatform]
  static void registerWith() => EspProvisioningPlatform.instance = EspProvisioningAndroid();
}
