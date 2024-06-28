import 'dart:io';

import 'package:esp_provisioning/esp_provisioning.dart';
import 'package:esp_provisioning_example/build_context_ext.dart';
import 'package:esp_provisioning_example/connect_page.dart';
import 'package:esp_provisioning_example/utilities.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanDevicesPage extends StatefulWidget {
  const ScanDevicesPage({required this.provisioner, super.key});

  final EspProvisioning provisioner;

  @override
  State<ScanDevicesPage> createState() => _ScanDevicesPageState();
}

class _ScanDevicesPageState extends State<ScanDevicesPage> {
  String? _deviceNamePrefix;
  List<EspBleDevice> _scannedDevices = [];
  var _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideKeyboard,
      child: Scaffold(
        appBar: AppBar(title: Text('EspProvisioning ${widget.provisioner.platformName}')),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _isScanning ? null : () => _scanTapped(context),
                      child: const Text('Scan'),
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
                  labelText: 'Device name prefix (optional, case sensitive)',
                  labelStyle: TextStyle(fontSize: 11),
                ),
                onSubmitted: (text) => setState(() => _deviceNamePrefix = text),
                onChanged: (text) => setState(() => _deviceNamePrefix = text),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _scannedDevices.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      title: Text(_scannedDevices[index].name),
                      subtitle: Text('RSSI: ${_scannedDevices[index].rssi}'),
                      onTap: () {
                        final page = ConnectPage(provisioner: widget.provisioner, device: _scannedDevices[index]);
                        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
                      },
                    ),
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
      if (context.mounted) context.showSimpleSnackBar('Bluetooth permissions were denied');

      return;
    }

    try {
      if (!context.mounted) return;

      setState(() {
        _scannedDevices = [];
        _isScanning = true;
      });

      context.showSimpleSnackBar('Scanning');
      final deviceNames = await widget.provisioner.scanForDevices(_deviceNamePrefix);

      if (!context.mounted) return;

      final length = deviceNames.length;
      context.showSimpleSnackBar('Found $length ${length == 1 ? 'device' : 'devices'}');
      setState(() {
        _scannedDevices = deviceNames;
        _isScanning = false;
      });
    } catch (error) {
      if (context.mounted) context.showSimpleSnackBar(error.toString());
    }
  }

  void _stopScanTapped() {
    setState(() => _isScanning = false);
    hideKeyboard();
    widget.provisioner.stopScan();
  }

  Future<bool> _checkBlePermissions() async {
    if (!Platform.isAndroid) return true;
    return await Permission.bluetoothConnect.request().isGranted && await Permission.bluetoothScan.request().isGranted;
  }
}
