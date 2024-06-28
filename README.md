# esp_provisioning

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Flutter Federated Plugin created by SpinDance that wraps the Espressif [Android](https://github.com/espressif/esp-idf-provisioning-android) and [iOS](https://github.com/espressif/esp-idf-provisioning-ios) Wi-Fi provisioning libraries.

IMPORTANT!
This plugin only supports Espressif BLE devices running [Protocomm Security 1](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/provisioning/protocomm.html).

To be clear, this plugin does not (yet) support:

- Espressif Protocomm Security0 devices
- Espressif Protocomm Security1 devices
- Espressif SoftAP devices

## Integration tests 🧪

Very Good Flutter Plugin uses [fluttium][fluttium_link] for integration tests. Those tests are located
in the front facing package `esp_provisioning` example.

**❗ In order to run the integration tests, you need to have the `fluttium_cli` installed. [See how][fluttium_install].**

To run the integration tests, run the following command from the root of the project:

```sh
cd esp_provisioning/example
fluttium test flows/test_platform_name.yaml
```

[coverage_badge]: esp_provisioning/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[fluttium_link]: https://fluttium.dev/
[fluttium_install]: https://fluttium.dev/docs/getting-started/installing-cli
