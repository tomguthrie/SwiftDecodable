import Foundation

/// JSON object type.
public typealias JSON = [String: Any]

/// Decodes JSON in a safe manner. Errors will be thrown describing why decoding failed.
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

    private func resolvedPath(_ key: String) -> String {
        let path = self.path + [key]
        return path.joined(separator: ".")
    }

    /// Possible errors thrown during decoding.
    public enum Error: Swift.Error {
        case missingKey(String)
        case wrongType(key: String, expected: Any.Type, actual: Any.Type)
        case invalidURL(key: String, stringValue: String)
        case invalidDate(key: String, stringValue: String)
        case invalidJSON(Any)
    }

    /// Decode url for key.
    public func value(forKey key: String) throws -> NSURL {
        let stringValue: String = try value(forKey: key)
        guard let url = NSURL(string: stringValue) else {
            throw Error.invalidURL(key: resolvedPath(key), stringValue: stringValue)
        }
        return url
    }

    /// Decode date for key using formatter.
    public func value(forKey key: String, formatter: DateFormatter) throws -> Date {
        let stringValue: String = try value(forKey: key)
        guard let date = formatter.date(from: stringValue) else {
            throw Error.invalidDate(key: resolvedPath(key), stringValue: stringValue)
        }
        return date
    }

    /// Decode ISO8601 date for key using formatter.
    @available(iOS 10.0, macOS 10.12, *)
    public func value(forKey key: String, formatter: ISO8601DateFormatter) throws -> Date {
        let stringValue: String = try value(forKey: key)
        guard let date = formatter.date(from: stringValue) else {
            throw Error.invalidDate(key: resolvedPath(key), stringValue: stringValue)
        }
        return date
    }

    /// Decode decodable value for key.
    public func value<Value: Decodable>(forKey key: String) throws -> Value {
        let json: JSON = try value(forKey: key)
        return try Value(decoder: Decoder(json: json, path: path + [key]))
    }

    /// Decode value for key.
    public func value<Value>(forKey key: String) throws -> Value {
        guard let value = json[key] as? Value else {
            guard let value = json[key] else {
                throw Error.missingKey(resolvedPath(key))
            }
            throw Error.wrongType(key: resolvedPath(key), expected: Value.self, actual: type(of: value))
        }
        return value
    }

    /// Decode an array of `Decodable` for `key`.
    public func array<Value: Decodable>(forKey key: String) throws -> [Value] {
        let array = try value(forKey: key) as [JSON]
        return try array.map(Value.init(json:))
    }

    /// Decode a sub decoder for `key`.
    public func decoder(forKey key: String) throws -> Decoder {
        let json = try value(forKey: key) as JSON
        return Decoder(json: json, path: self.path + [key])
    }

    private func ignoreMissingKeyError<Value>(_ expression: @autoclosure () throws -> Value) throws -> Value? {
        do {
            return try expression()
        } catch Error.missingKey {
            return nil
        } catch {
            throw error
        }
    }

    /// Decode url for key, returning nil if not found.
    public func optionalValue(forKey key: String) throws -> NSURL? {
        return try ignoreMissingKeyError(value(forKey: key))
    }

    /// Decode date for key using a formatter, returning nil if not found.
    public func optionalValue(forKey key: String, formatter: DateFormatter) throws -> Date? {
        return try ignoreMissingKeyError(value(forKey: key, formatter: formatter))
    }

    /// Decode decodable value for key, returning nil if not found.
    public func optionalValue<Value: Decodable>(forKey key: String) throws -> Value? {
        return try ignoreMissingKeyError(value(forKey: key))
    }

    /// Decode value for key, returning nil if not found.
    public func optionalValue<Value>(forKey key: String) throws -> Value? {
        return try ignoreMissingKeyError(value(forKey: key))
    }
}
