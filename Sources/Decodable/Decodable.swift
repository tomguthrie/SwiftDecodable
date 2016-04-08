protocol Decodable {
    init(decoder: Decoder) throws
}

extension Decodable {
    init(json: JSON) throws {
        try self.init(decoder: Decoder(json: json))
    }
}
