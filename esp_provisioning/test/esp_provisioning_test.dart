import 'package:esp_provisioning/esp_provisioning.dart';
import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEspProvisioningPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements EspProvisioningPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const deviceA = EspBleDevice(name: 'device A', rssi: -50);
  const deviceB = EspBleDevice(name: 'device B', rssi: -60);

  group('EspProvisioning', () {
    final subject = EspProvisioning();
    late EspProvisioningPlatform espProvisioningPlatform;

    setUp(() {
      espProvisioningPlatform = MockEspProvisioningPlatform();
      EspProvisioningPlatform.instance = espProvisioningPlatform;
    });

    test('platformName', () async {
      const platformName = 'test_platform';
      when(() => espProvisioningPlatform.platformName).thenReturn(platformName);
      expect(subject.platformName, equals(platformName));
    });

    test('scanForDevices', () async {
      const prefix = 'name prefix';
      const devices = [deviceA, deviceB];
      when(() => espProvisioningPlatform.scanForEspDevices(prefix)).thenAnswer((_) async => devices.map((d) => d.name).toList());
      expect(await subject.scanForDevices(prefix), devices);
    });

    test('stopScan', () {
      when(() => espProvisioningPlatform.stopEspDeviceScan()).thenAnswer((_) async {});
      expect(subject.stopScan(), completes);
    });
  });
}
