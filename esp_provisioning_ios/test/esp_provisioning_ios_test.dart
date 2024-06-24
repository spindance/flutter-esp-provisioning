import 'package:esp_provisioning_ios/esp_provisioning_ios.dart';
import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EspProvisioningIos', () {
    late EspProvisioningIos espProvisioning;

    setUp(() => espProvisioning = EspProvisioningIos());

    test('defines the correct String constants', () {
      expect(espProvisioning.methodChannelName, 'esp_provisioning_ios');
      expect(espProvisioning.platformName, 'iOS');
    });

    test('can be registered', () {
      EspProvisioningIos.registerWith();
      expect(EspProvisioningPlatform.instance, isA<EspProvisioningIos>());
    });
  });
}
