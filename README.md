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

## Dependencies

We are using explicit versions of `json_annotation` (`v4.8.1`) and `json_serializable` (`v6.7.1`) to be compatible with Amplify Flutter v2, which is used by [Callbox Flutter](https://github.com/spindance/callbox-mobile-flutter). This is the `flutter pub get` output when using more recent versions of those package (that is, this is the issue we are working around by using the older versions):

```bash
[packages/callbox_sdk] flutter pub get --no-example
Resolving dependencies...
Because aws_common 0.7.0 depends on json_annotation >=4.8.1 <4.9.0 and no versions of aws_common match >0.7.0 <0.8.0, aws_common ^0.7.0 requires json_annotation >=4.8.1 <4.9.0.
And because every version of esp_provisioning from git depends on json_annotation ^4.9.0 and amplify_flutter >=2.0.0 depends on aws_common ^0.7.0, esp_provisioning from git is incompatible with amplify_flutter >=2.0.0.
So, because callbox_sdk depends on both amplify_flutter ^2.0.0 and esp_provisioning from git, version solving failed.
```

[coverage_badge]: esp_provisioning/coverage_badge.svg
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
