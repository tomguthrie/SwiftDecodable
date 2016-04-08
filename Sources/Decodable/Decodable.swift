/// Type that can be decoded from JSON.
public protocol Decodable {
    init(decoder: Decoder) throws
}

extension Decodable {
    public init(json: JSON) throws {
        try self.init(decoder: Decoder(json: json))
    }
}
