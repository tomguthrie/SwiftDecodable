import Foundation

/// Represents a JSON object type.
typealias JSON = [String: AnyObject]

/// Faciliates decoding a JSON object.
struct Decoder {
    let json: JSON
    let path: [String]

    init(json: JSON) {
        self.json = json
        self.path = []
    }

    private init(json: JSON, path: [String]) {
        self.json = json
        self.path = path
    }

    private func resolvedPath(key: String) -> String {
        let path = self.path + [key]
        return path.joined(separator: ".")
    }

    /// Error that has occured during decoding.
    enum Error: ErrorProtocol {
        case MissingKey(String)
        case WrongType(key: String, expected: Any.Type, actual: Any.Type)
        case InvalidURL(key: String, stringValue: String)
        case InvalidDate(key: String, stringValue: String, formatter: NSDateFormatter)
    }

    /// Decode an `NSURL` located at `key`, throws Error including Error.InvalidURL.
    func decode(key: String) throws -> NSURL {
        let stringValue: String = try decode(key)

        guard let url = NSURL(string: stringValue) else {
            throw Error.InvalidURL(key: resolvedPath(key), stringValue: stringValue)
        }

        return url
    }

    /// Decode an `NSDate` located at `key`, throws Error including Error.InvalidDate.
    func decode(key: String, formatter: NSDateFormatter) throws -> NSDate {
        let stringValue: String = try decode(key)

        guard let date = formatter.date(from: stringValue) else {
            throw Error.InvalidDate(key: resolvedPath(key), stringValue: stringValue, formatter: formatter)
        }

        return date
    }

    /// Decode a `Decodable` `Value` located at `key`, throws Error.
    func decode<Value: Decodable>(key: String) throws -> Value {
        let json: JSON = try decode(key)
        return try Value(decoder: Decoder(json: json, path: path + [key]))
    }

    /// Decode a `Value` located at `key`, throws Error.
    func decode<Value>(key: String) throws -> Value {
        guard let value = json[key] as? Value else {
            guard let value = json[key] else {
                throw Error.MissingKey(resolvedPath(key))
            }

            throw Error.WrongType(key: resolvedPath(key), expected: Value.self, actual: value.dynamicType)
        }

        return value
    }
}
