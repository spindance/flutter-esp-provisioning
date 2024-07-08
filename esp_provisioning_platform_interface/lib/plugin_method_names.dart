/// MethodChannel function names used in the Android and iOS plugins; must be modified with care!
class PluginMethodNames {
  /// Method name to scan for BLE devices.
  static const scanBleDevices = 'scanBleDevices';

  /// Method name to stop scanning for BLE devices.
  static const stopBleDeviceScan = 'stopBleDeviceScan';

  /// Method name to connect to a BLE device.
  static const connect = 'connect';

  /// Method name to disconnect from a BLE device.
  static const disconnect = 'disconnect';

  /// Method name to get the list of access points available to the ESP device.
  static const getAccessPoints = 'getAccessPoints';

  /// Method name to set the access point on the ESP device.
  static const setAccessPoint = 'setAccessPoint';

  /// Method name to send Base64 encoded data to the ESP device.
  static const sendData = 'sendData';

  static const sendBytes = 'sendBytes';
}
