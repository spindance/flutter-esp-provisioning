import 'package:esp_provisioning/esp_provisioning.dart';
import 'package:esp_provisioning_example/build_context_ext.dart';
import 'package:esp_provisioning_example/set_access_point_page.dart';
import 'package:flutter/material.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({required this.provisioner, required this.device, super.key});

  final EspProvisioning provisioner;
  final EspBleDevice device;

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  List<EspWifiAccessPoint> _accessPoints = [];
  bool _isConnected = false;
  bool _isBusy = false;
  bool get _enableDisconnect => _isConnected && !_isBusy;
  bool get _enableConnect => !_isConnected && !_isBusy;
  bool get _enableGetAccessPoints => _isConnected && !_isBusy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.device.name)),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _enableConnect ? () => _connectTapped(context) : null,
                    child: const Text('Connect'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _enableDisconnect ? () => _disconnectTapped(context) : null,
                    child: const Text('Disconnect'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _enableGetAccessPoints ? () => _getAccessPoints(context) : null,
                    child: const Text('Get Access Points'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _enableDisconnect ? () => _showSetAccessPointPage(null) : null,
                    child: const Text('Enter SSID Manually'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _accessPoints.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(_accessPoints[index].ssid),
                    subtitle: Text('RSSI: ${_accessPoints[index].rssi}, ${_accessPoints[index].security.name}'),
                    onTap: () => _showSetAccessPointPage(_accessPoints[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _connectTapped(BuildContext context) async {
    var message = 'Connected';
    setState(() => _isBusy = true);

    try {
      await widget.provisioner.connect(widget.device.name, '12345678-90AB-CDEF-FEDC-BA0987654321', null);
      setState(() => _isConnected = true);
    } catch (e) {
      message = 'Failed to connect: $e';
    }

    if (context.mounted) context.showSimpleSnackBar(message);
    setState(() => _isBusy = false);
  }

  Future<void> _disconnectTapped(BuildContext context) async {
    setState(() => _isBusy = true);

    try {
      await widget.provisioner.disconnect(widget.device.name);
      setState(() {
        _isConnected = false;
        _accessPoints = [];
      });
    } catch (e) {
      if (!context.mounted) return;
      context.showSimpleSnackBar('Failed to disconnect: $e');
    }

    setState(() => _isBusy = false);
  }

  Future<void> _getAccessPoints(BuildContext context) async {
    String message;

    context.showSimpleSnackBar('Getting access points');

    setState(() {
      _isBusy = true;
      _accessPoints = [];
    });

    try {
      final accessPoints = await widget.provisioner.getAccessPoints(widget.device.name);
      message = 'Found ${accessPoints.length} access points';
      setState(() => _accessPoints = accessPoints);
    } catch (e) {
      message = e.toString();
    }

    setState(() => _isBusy = false);

    if (context.mounted) context.showSimpleSnackBar(message);
  }

  void _showSetAccessPointPage(EspWifiAccessPoint? accessPoint) {
    final page = SetAccessPointPage(provisioner: widget.provisioner, device: widget.device, accessPoint: accessPoint);
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}
