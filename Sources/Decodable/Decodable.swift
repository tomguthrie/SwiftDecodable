import Foundation

/// Represents a type that can be decoded from JSON.
public protocol Decodable {
    init(decoder: Decoder) throws
}

extension Decodable {
    public init(json: JSON) throws {
        let decoder = Decoder(json: json)
        try self.init(decoder: decoder)
    }

    public init(data: NSData) throws {
        let jsonObject = try NSJSONSerialization.jsonObject(with: data, options: [])
        guard let json = jsonObject as? JSON else {
            throw Decoder.Error.invalidJSON(jsonObject)
        }
        try self.init(json: json)
    }
}
