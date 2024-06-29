# esp_provisioning

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

A Flutter Federated Plugin created by SpinDance that wraps the Espressif [Android](https://github.com/espressif/esp-idf-provisioning-android) and [iOS](https://github.com/espressif/esp-idf-provisioning-ios) Wi-Fi provisioning libraries.

IMPORTANT!
This plugin only supports Espressif BLE devices running [Protocomm Security 1](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/provisioning/protocomm.html).

To be clear, this plugin does not (yet) support:

- Espressif Protocomm Security0 devices
- Espressif Protocomm Security1 devices
- Espressif SoftAP devices

## Development

- This codebase uses a 120 character line length.
- `dart format` and `flutter analyze` can be run via the script `format-and-analyze.sh`.
- All Dart unit tests can be run from VS Code.
- Dart unit tests for each package can be run from the command line by changing into the package's directory and running `flutter test`.

[coverage_badge]: esp_provisioning/coverage_badge.svg
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
