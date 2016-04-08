@testable import Decodable

struct Person: Decodable {
    let name: Name
    let age: Int
    let email: String?

    init(decoder: Decoder) throws {
        self.name = try decoder.decode("name")
        self.age = try decoder.decode("age")
        self.email = try decoder.decode("email")
    }

    struct Name: Decodable {
        let first: String
        let second: String

        init(decoder: Decoder) throws {
            self.first = try decoder.decode("first")
            self.second = try decoder.decode("second")
        }
    }
}