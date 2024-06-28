import 'package:esp_provisioning/esp_provisioning.dart';
import 'package:esp_provisioning_example/build_context_ext.dart';
import 'package:esp_provisioning_example/utilities.dart';
import 'package:flutter/material.dart';

class SetAccessPointPage extends StatefulWidget {
  const SetAccessPointPage(
      {required this.provisioner,
      required this.device,
      required this.accessPoint,
      super.key});

  final EspProvisioning provisioner;
  final EspBleDevice device;
  final EspWifiAccessPoint? accessPoint;

  @override
  State<SetAccessPointPage> createState() => _SetAccessPointPageState();
}

class _SetAccessPointPageState extends State<SetAccessPointPage> {
  String _ssid = '';
  String _password = '';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    setState(() => _ssid = widget.accessPoint?.ssid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final ssid = widget.accessPoint?.ssid;

    return GestureDetector(
      onTap: hideKeyboard,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.device.name)),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(ssid == null
                        ? 'Enter the SSID'
                        : "Enter password for '$ssid'"),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: ssid,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Access Point SSID',
                      ),
                      onFieldSubmitted: (text) => setState(() => _ssid = text),
                      onChanged: (text) => setState(() => _ssid = text),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Access Point Password',
                      ),
                      onSubmitted: (text) => setState(() => _password = text),
                      onChanged: (text) => setState(() => _password = text),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:
                          _busy ? null : () => _setAccessPointTapped(context),
                      child: const Text('Set Access Point'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setAccessPointTapped(BuildContext context) async {
    setState(() => _busy = true);
    hideKeyboard();

    try {
      await widget.provisioner
          .setAccessPoint(widget.device.name, _ssid, _password);
      if (!context.mounted) return;

      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Center(child: Text('Access point set successfully')),
          content: const Text('The device is now disconnected.'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted)
        context.showSimpleSnackBar('Failed to set access point: $e');
      setState(() => _busy = false);
    }
  }
}
