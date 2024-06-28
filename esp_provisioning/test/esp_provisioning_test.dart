import 'dart:async';

import 'package:esp_provisioning/esp_provisioning.dart';
import 'package:esp_provisioning_platform_interface/esp_provisioning_platform_interface.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEspProvisioningPlatform extends Mock with MockPlatformInterfaceMixin implements EspProvisioningPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const deviceA = EspBleDevice(name: 'device A', rssi: -50);
  const deviceB = EspBleDevice(name: 'device B', rssi: -60);
  const devices = [deviceA, deviceB];

  const ap = EspWifiAccessPoint(ssid: 'ssid', channel: 1, security: EspWifiAccessPointSecurity.wep, rssi: -1);

  /// MethodChannel returns the BLE and Access Point scan result JSON strings in a strange format. This format with
  /// double quotes inside single quotes seems to match what it returns. Simply converting the objects in question to
  /// JSON strings did not work here in unit tests.
  final deviceAJsonString = '{"name": "${deviceA.name}", "rssi": ${deviceA.rssi}}';
  final deviceBJsonString = '{"name": "${deviceB.name}", "rssi": ${deviceB.rssi}}';
  final deviceJsonStrings = [deviceAJsonString, deviceBJsonString];
  final accessPointJsonString =
      '{"ssid": "${ap.ssid}", "channel": ${ap.channel}, "security": "${ap.security.value}", "rssi": ${ap.rssi}}';

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
      when(() => espProvisioningPlatform.scanForEspDevices(prefix)).thenAnswer((_) async => deviceJsonStrings);
      expect(await subject.scanForDevices(prefix), devices);
      verify(() => espProvisioningPlatform.scanForEspDevices(prefix)).called(1);
    });

    test('stopScan', () async {
      when(() => espProvisioningPlatform.stopEspDeviceScan()).thenAnswer((_) async {});
      await subject.stopScan();
      verify(() => espProvisioningPlatform.stopEspDeviceScan()).called(1);
    });

    test('connect', () async {
      when(() => espProvisioningPlatform.connectDevice(deviceA.name, 'uuid', null)).thenAnswer((_) async {});
      await subject.connect(deviceA.name, 'uuid', null);
      verify(() => espProvisioningPlatform.connectDevice(deviceA.name, 'uuid', null)).called(1);
    });

    test('disconnect', () async {
      when(() => espProvisioningPlatform.disconnectDevice(deviceA.name)).thenAnswer((_) async {});
      await subject.disconnect(deviceA.name);
      verify(() => espProvisioningPlatform.disconnectDevice(deviceA.name)).called(1);
    });

    test('getAccessPoints', () async {
      when(() => espProvisioningPlatform.getEspAccessPoints(deviceA.name))
          .thenAnswer((_) async => [accessPointJsonString]);
      expect(await subject.getAccessPoints(deviceA.name), [ap]);
      verify(() => espProvisioningPlatform.getEspAccessPoints(deviceA.name)).called(1);
    });

    test('getAccessPoints throws upon timeout', () async {
      fakeAsync((async) {
        when(() => espProvisioningPlatform.getEspAccessPoints(deviceA.name)).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(seconds: 2));
          return [accessPointJsonString];
        });
        expect(() => subject.getAccessPoints(deviceA.name, 1), throwsA(isA<TimeoutException>()));
        verify(() => espProvisioningPlatform.getEspAccessPoints(deviceA.name)).called(1);
        async.elapse(const Duration(seconds: 1));
      });
    });

    test('setAccessPoint', () async {
      const password = 'password';
      when(() => espProvisioningPlatform.setEspAccessPoint(deviceA.name, ap.ssid, password)).thenAnswer((_) async {});
      await subject.setAccessPoint(deviceA.name, ap.ssid, password);
      verify(() => espProvisioningPlatform.setEspAccessPoint(deviceA.name, ap.ssid, password)).called(1);
    });

    test('setAccessPoint throws upon timeout', () {
      fakeAsync((async) {
        const password = 'password';
        when(() => espProvisioningPlatform.setEspAccessPoint(deviceA.name, ap.ssid, password)).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(seconds: 2));
        });
        expect(() => subject.setAccessPoint(deviceA.name, ap.ssid, password, 1), throwsA(isA<TimeoutException>()));
        verify(() => espProvisioningPlatform.setEspAccessPoint(deviceA.name, ap.ssid, password)).called(1);
        async.elapse(const Duration(seconds: 1));
      });
    });

    test('sendDataToEndpoint', () async {
      const endpoint = 'endpoint';
      const data = 'data';
      const response = 'response';
      when(() => espProvisioningPlatform.sendData(deviceA.name, endpoint, data)).thenAnswer((_) async => response);
      expect(await subject.sendDataToEndpoint(deviceA.name, endpoint, data), response);
      verify(() => espProvisioningPlatform.sendData(deviceA.name, endpoint, data)).called(1);
    });

    test('sendDataToEndpoint throws upon timeout', () {
      fakeAsync((async) {
        const endpoint = 'endpoint';
        const data = 'data';
        const response = 'response';
        when(() => espProvisioningPlatform.sendData(deviceA.name, endpoint, data)).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(seconds: 2));
          return response;
        });
        expect(() => subject.sendDataToEndpoint(deviceA.name, endpoint, data, 1), throwsA(isA<TimeoutException>()));
        verify(() => espProvisioningPlatform.sendData(deviceA.name, endpoint, data)).called(1);
        async.elapse(const Duration(seconds: 1));
      });
    });
  });
}
