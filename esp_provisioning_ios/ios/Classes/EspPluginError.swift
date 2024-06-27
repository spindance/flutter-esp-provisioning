import Foundation

enum EspPluginError: Error {
  case jsonSerializationError
  case deviceNotFound
  case invalidMethodChannelInputs(String)
  case unexpectedError(String)

  var errorCodeString: String {
    let baseString = "\(self)"
    var errorDescription = ""

    switch self {
    case .jsonSerializationError, .deviceNotFound: return baseString
    case .invalidMethodChannelInputs(let methodName): return "\(baseString): \(methodName)"
    case .unexpectedError(let description): return "\(baseString): \(description)"
    }
  }
}
