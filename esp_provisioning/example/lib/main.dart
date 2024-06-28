import 'package:esp_provisioning/esp_provisioning.dart';
import 'package:esp_provisioning_example/scan_devices_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const EspProvisioningExample());

class EspProvisioningExample extends StatelessWidget {
  const EspProvisioningExample({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: ScanDevicesPage(provisioner: EspProvisioning()));
}
