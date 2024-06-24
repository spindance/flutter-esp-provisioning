import 'package:esp_provisioning/esp_provisioning.dart';
import 'package:esp_provisioning_example/utilities.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _provisioner = EspProvisioning();
  String? _deviceNamePrefix;
  List<String> _scannedDeviceNames = [];
  var _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideKeyboard,
      child: Scaffold(
        appBar: AppBar(title: Text('EspProvisioning ${_provisioner.platformName}')),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _isScanning ? null : () => _scanTapped(context),
                      child: const Text('Scan for Devices'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _isScanning ? _stopScanTapped : null,
                      child: const Text('Stop Scan'),
                    ),
                  ],
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Optional device name prefix (case sensitive)',
                ),
                onSubmitted: (text) => setState(() => _deviceNamePrefix = text),
                onChanged: (text) => setState(() => _deviceNamePrefix = text),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _scannedDeviceNames.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(_scannedDeviceNames[index]),
                    onTap: () => debugPrint('TODO'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanTapped(BuildContext context) async {
    hideKeyboard();

    if (!(await _checkBlePermissions())) {
      if (context.mounted) {
        _showSnackBar(context, 'Bluetooth permissions were denied');
      }

      return;
    }

    try {
      if (!context.mounted) return;

      setState(() {
        _scannedDeviceNames = [];
        _isScanning = true;
      });

      _showSnackBar(context, 'Scanning');
      final deviceNames = await _provisioner.scanForDevices(_deviceNamePrefix);

      if (!context.mounted) return;

      final length = deviceNames.length;
      _showSnackBar(context, 'Found $length ${length == 1 ? 'device' : 'devices'}');
      setState(() {
        _scannedDeviceNames = deviceNames;
        _isScanning = false;
      });
    } catch (error) {
      if (!context.mounted) return;
      _showSnackBar(context, '$error');
    }
  }

  void _stopScanTapped() {
    setState(() => _isScanning = false);
    hideKeyboard();
    _provisioner.stopScan();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Theme.of(context).primaryColor, content: Text(message)),
    );
  }

  Future<bool> _checkBlePermissions() async =>
      await Permission.bluetoothConnect.request().isGranted && await Permission.bluetoothScan.request().isGranted;
}
