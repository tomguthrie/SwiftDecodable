import Foundation

/// Represents a JSON object type.
typealias JSON = [String: AnyObject]

/// Faciliates decoding a JSON object.
struct Decoder {
    let json: JSON

    init(json: JSON) {
        self.json = json
    }

    /// Error that has occured during decoding.
    enum Error: ErrorProtocol {
        case MissingKey(String)
        case WrongType(key: String, expected: Any.Type, actual: Any.Type)
        case InvalidURL(key: String, stringValue: String)
        case InvalidDate(key: String, stringValue: String, formatter: NSDateFormatter)
    }

    /// Decode an `NSURL` located at `key` throws Error including Error.InvalidURL.
    func decode(key: String) throws -> NSURL {
        let stringValue: String = try decode(key)

        guard let url = NSURL(string: stringValue) else {
            throw Error.InvalidURL(key: key, stringValue: stringValue)
        }

        return url
    }

    /// Decode an `NSDate` located at `key` throws Error including Error.InvalidDate.
    func decode(key: String, formatter: NSDateFormatter) throws -> NSDate {
        let stringValue: String = try decode(key)

        guard let date = formatter.date(from: stringValue) else {
            throw Error.InvalidDate(key: key, stringValue: stringValue, formatter: formatter)
        }

        return date
    }

    /// Decode a `Value` located at `key` throws Error.
    func decode<Value>(key: String) throws -> Value {
        guard let value = json[key] as? Value else {
            guard let value = json[key] else {
                throw Error.MissingKey(key)
            }

            throw Error.WrongType(key: key, expected: Value.self, actual: value.dynamicType)
        }

        return value
    }
}
