import ESPProvision
import Flutter
import Foundation

enum Utilities {
  static func reportFailure(
    with error: Error,
    resultCallback: @escaping FlutterResult,
    message: String? = nil,
    file: String = #file,
    function: String = #function,
    line: Int = #line
  ) {
    let description: String
    let errorCodeString: String

    if let error = error as? EspPluginError {
      description = error.errorCodeString
      errorCodeString = error.errorCodeString
    } else if let error = error as? ESPError {
      description = "\(error.self): \(error.description)"
      errorCodeString = "ESPError code: \(error.code)"
    } else {
      description = error.localizedDescription
      errorCodeString = "\(error.self)"
    }

    printError(error, message: message ?? description, file: file, function: function, line: line)
    resultCallback(FlutterError(code: errorCodeString, message: description, details: nil))
  }

  static func printError(
    _ error: Error,
    message: String? = "",
    file: String = #file,
    function: String = #function,
    line: Int = #line
  ) {
    let filename = formatFileName(file: file)
    print("Error: \(filename) \(function) line: \(line): \(message ?? ""), error: \(error)")
  }

  static func log(
    message: String,
    file: String = #file,
    function: String = #function,
    line: Int = #line
  ) {
    let filename = formatFileName(file: file)
    print("Logger: \(filename) \(function) line: \(line): \(message)")
  }

  static func formatFileName(file: String) -> String {
    return file.components(separatedBy: "/").last ?? ""
  }
}
