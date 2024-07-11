import 'package:esp_provisioning_android/esp_provisioning_android.dart';
import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EspProvisioningAndroid', () {
    late EspProvisioningAndroid espProvisioning;

    setUp(() => espProvisioning = EspProvisioningAndroid());

    test('defines the correct String constants', () {
      expect(espProvisioning.methodChannelName, 'esp_provisioning_android');
      expect(espProvisioning.platformName, 'Android');
    });

    test('can be registered', () {
      EspProvisioningAndroid.registerWith();
      expect(EspProvisioningPlatform.instance, isA<EspProvisioningAndroid>());
    });
  });
}
