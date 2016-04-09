import Foundation

/// Represents a JSON object type.
public typealias JSON = [String: AnyObject]

/// Faciliates decoding a JSON object.
public struct Decoder {
    public let json: JSON
    public let path: [String]

    public init(json: JSON) {
        self.json = json
        self.path = []
    }

    init(json: JSON, path: [String]) {
        self.json = json
        self.path = path
    }

    func resolvedPath(key: String) -> String {
        let path = self.path + [key]
        return path.joined(separator: ".")
    }

    /// Error that has occured during decoding.
    public enum Error: ErrorProtocol {
        case missingKey(String)
        case wrongType(key: String, expected: Any.Type, actual: Any.Type)
        case invalidURL(key: String, stringValue: String)
        case invalidDate(key: String, stringValue: String, formatter: NSDateFormatter)
        case invalidJSON(AnyObject)
    }

    /// Decode an `NSURL` located at `key`, throws Error including Error.InvalidURL.
    public func decode(key: String) throws -> NSURL {
        let stringValue: String = try decode(key)

        guard let url = NSURL(string: stringValue) else {
            throw Error.invalidURL(key: resolvedPath(key), stringValue: stringValue)
        }

        return url
    }

    /// Decode an `NSDate` located at `key`, throws Error including Error.InvalidDate.
    public func decode(key: String, formatter: NSDateFormatter) throws -> NSDate {
        let stringValue: String = try decode(key)

        guard let date = formatter.date(from: stringValue) else {
            throw Error.invalidDate(key: resolvedPath(key), stringValue: stringValue, formatter: formatter)
        }

        return date
    }

    /// Decode a `Decodable` `Value` located at `key`, throws Error.
    public func decode<Value: Decodable>(key: String) throws -> Value {
        let json: JSON = try decode(key)
        return try Value(decoder: Decoder(json: json, path: path + [key]))
    }

    /// Decode a `Value` located at `key`, throws Error.
    public func decode<Value>(key: String) throws -> Value {
        guard let value = json[key] as? Value else {
            guard let value = json[key] else {
                throw Error.missingKey(resolvedPath(key))
            }

            throw Error.wrongType(key: resolvedPath(key), expected: Value.self, actual: value.dynamicType)
        }

        return value
    }

    func ignoreMissingKey<Value>(@autoclosure expression: () throws -> Value) throws -> Value? {
        do {
            return try expression()
        } catch Error.missingKey {
            return nil
        } catch {
            throw error
        }
    }

    /// Decode an `NSURL` located at `key`, throws Error including Error.InvalidURL but will return
    /// nil if key is missing.
    public func decodeOptional(key: String) throws -> NSURL? {
        return try ignoreMissingKey(try decode(key))
    }

    /// Decode an `NSDate` located at `key`, throws Error including Error.InvalidDate but will return
    /// nil if key is missing.
    public func decodeOptional(key: String, formatter: NSDateFormatter) throws -> NSDate? {
        return try ignoreMissingKey(try decode(key))
    }

    /// Decode a `Decodable` `Value` located at `key`, throws Error but will return nil if key is
    /// missing.
    public func decodeOptional<Value: Decodable>(key: String) throws -> Value? {
        return try ignoreMissingKey(try decode(key))
    }

    /// Decode `Value` located at `key`, throws Error but will return nil if key is missing.
    public func decodeOptional<Value>(key: String) throws -> Value? {
        return try ignoreMissingKey(try decode(key))
    }
}
