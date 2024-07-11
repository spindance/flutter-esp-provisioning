import Foundation

extension Encodable {
  func asJsonString() throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let json = try encoder.encode(self)

    guard let jsonString = String(data: json, encoding: .utf8) else {
      throw EspPluginError.jsonSerializationError
    }

    return jsonString
  }
}
