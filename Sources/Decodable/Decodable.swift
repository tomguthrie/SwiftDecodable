import Foundation

/// Type that can be decoded from JSON.
public protocol Decodable {
    init(decoder: Decoder) throws
}

extension Decodable {
    public init(json: JSON) throws {
        try self.init(decoder: Decoder(json: json))
    }

    public init(data: NSData) throws {
        let jsonObject = try NSJSONSerialization.jsonObject(with: data, options: [])

        guard let json = jsonObject as? JSON else {
            throw Decoder.Error.invalidJSON(jsonObject)
        }

        try self.init(json: json)
    }
}
