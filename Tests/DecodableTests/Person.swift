@testable import Decodable

struct Person: Decodable {
    let name: Name
    let age: Int
    let email: String?

    init(decoder: Decoder) throws {
        self.name = try decoder.value(forKey: "name")
        self.age = try decoder.value(forKey: "age")
        self.email = try decoder.optionalValue(forKey: "email")
    }

    struct Name: Decodable {
        let first: String
        let second: String

        init(decoder: Decoder) throws {
            self.first = try decoder.value(forKey: "first")
            self.second = try decoder.value(forKey: "second")
        }
    }
}
