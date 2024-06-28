import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _EspProvisioningMock extends EspProvisioningPlatform {
  @override
  final String platformName = 'Mock';

  @override
  final String methodChannelName = 'esp_provisioning_mock';

  static void registerWith() => EspProvisioningPlatform.instance = _EspProvisioningMock();
}

void main() {
  late EspProvisioningPlatform subject;
  late List<MethodCall> log;
  const scannedDeviceNames = ['device1', 'device2'];
  const deviceName = 'Device';

  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  group('EspProvisioningPlatformInterface', () {
    setUp(() {
      subject = _EspProvisioningMock();
      EspProvisioningPlatform.instance = subject;
      log = <MethodCall>[];

      messenger.setMockMethodCallHandler(subject.methodChannel, (methodCall) async {
        log.add(methodCall);

        switch (methodCall.method) {
          case 'scanBleDevices':
            return scannedDeviceNames;
          case 'stopBleDeviceScan':
            return null;
          case 'connect':
            return null;
          case 'disconnect':
            return null;
          case 'getAccessPoints':
            return List<String>.empty();
          case 'setAccessPoint':
            return null;
          case 'sendData':
            return '';
          default:
            return null;
        }
      });
    });

    test('instance access', () {
      _EspProvisioningMock.registerWith();
      expect(EspProvisioningPlatform.instance, isA<_EspProvisioningMock>());
    });

    test('scanForEspDevices', () async {
      const prefix = 'Prefix';
      final result = await subject.scanForEspDevices(prefix);
      expect(log, <Matcher>[isMethodCall('scanBleDevices', arguments: prefix)]);
      expect(result, equals(scannedDeviceNames));
    });

    test('scanForEspDevices throws when return value is null', () async {
      messenger.setMockMethodCallHandler(subject.methodChannel, (methodCall) async => null);
      expect(() async => subject.scanForEspDevices(null), throwsA(isA<Exception>()));
    });

    test('stopEspDeviceScan', () async {
      await subject.stopEspDeviceScan();
      expect(log, <Matcher>[isMethodCall('stopBleDeviceScan', arguments: null)]);
    });

    test('connectDevice', () async {
      const provisioningServiceUuid = 'UUID';
      const proofOfPossession = 'Proof';
      await subject.connectDevice(deviceName, provisioningServiceUuid, proofOfPossession);

      final expectedArguments = <String, dynamic>{
        'deviceName': deviceName,
        'provisioningServiceUuid': provisioningServiceUuid,
        'proofOfPossession': proofOfPossession,
      };

      expect(log, <Matcher>[isMethodCall('connect', arguments: expectedArguments)]);
    });

    test('disconnectDevice', () async {
      await subject.disconnectDevice(deviceName);
      expect(log, <Matcher>[isMethodCall('disconnect', arguments: deviceName)]);
    });

    test('getEspAccessPoints', () async {
      await subject.getEspAccessPoints(deviceName);
      expect(log, <Matcher>[isMethodCall('getAccessPoints', arguments: deviceName)]);
    });

    test('getEspAccessPoints throws when return value is null', () async {
      messenger.setMockMethodCallHandler(subject.methodChannel, (methodCall) async => null);
      expect(() async => subject.getEspAccessPoints(deviceName), throwsA(isA<Exception>()));
    });

    test('setAccessPoint', () async {
      const ssid = 'SSID';
      const password = 'Password';
      await subject.setEspAccessPoint(deviceName, ssid, password);

      final expectedArguments = <String, dynamic>{
        'deviceName': deviceName,
        'ssid': ssid,
        'password': password,
      };

      expect(log, <Matcher>[isMethodCall('setAccessPoint', arguments: expectedArguments)]);
    });

    test('sendData', () async {
      const endpoint = 'Endpoint';
      const data = 'Data';
      await subject.sendData(deviceName, endpoint, data);

      final expectedArguments = <String, dynamic>{
        'deviceName': deviceName,
        'endpointPath': endpoint,
        'base64Data': data,
      };

      expect(log, <Matcher>[isMethodCall('sendData', arguments: expectedArguments)]);
    });

    test('sendData throws when return value is null', () async {
      messenger.setMockMethodCallHandler(subject.methodChannel, (methodCall) async => null);
      expect(() async => subject.sendData(deviceName, 'Endpoint', 'Data'), throwsA(isA<Exception>()));
    });
  });
}
