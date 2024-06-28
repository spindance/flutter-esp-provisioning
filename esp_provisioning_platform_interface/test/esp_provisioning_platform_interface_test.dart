import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _EspProvisioningMock extends EspProvisioningPlatform {
  @override
  final String platformName = 'Mock';

  @override
  final String methodChannelName = 'esp_provisioning_mock';
}

void main() {
  late EspProvisioningPlatform espProvisioning;
  late List<MethodCall> log;
  const scannedDeviceNames = ['device1', 'device2'];

  TestWidgetsFlutterBinding.ensureInitialized();

  group('EspProvisioningPlatformInterface', () {
    setUp(() {
      espProvisioning = _EspProvisioningMock();
      EspProvisioningPlatform.instance = espProvisioning;
      log = <MethodCall>[];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(espProvisioning.methodChannel, (methodCall) async {
        log.add(methodCall);

        switch (methodCall.method) {
          case 'scanBleDevices':
            return scannedDeviceNames;
          case 'stopBleDeviceScan':
            return null;
          default:
            return null;
        }
      });
    });

    test('scanForEspDevices', () async {
      const prefix = 'Prefix';
      final result = await espProvisioning.scanForEspDevices(prefix);
      expect(log, <Matcher>[isMethodCall('scanBleDevices', arguments: prefix)]);
      expect(result, equals(scannedDeviceNames));
    });

    test('stopEspDeviceScan', () async {
      await espProvisioning.stopEspDeviceScan();
      expect(log, <Matcher>[isMethodCall('stopBleDeviceScan', arguments: null)]);
    });
  });
}
