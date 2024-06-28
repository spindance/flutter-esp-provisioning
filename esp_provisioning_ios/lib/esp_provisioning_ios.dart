import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';

/// The iOS implementation of [EspProvisioningPlatform].
class EspProvisioningIos extends EspProvisioningPlatform {
  @override
  final methodChannelName = 'esp_provisioning_ios';

  @override
  final String platformName = 'iOS';

  /// Registers this class as the default instance of [EspProvisioningPlatform].
  static void registerWith() =>
      EspProvisioningPlatform.instance = EspProvisioningIos();
}
