import XCTest
@testable import Decodable

class DecodableTests: XCTestCase {
    func testDecodesPerson() throws {
        let person = try Person(json: [
            "name": [
                "first": "John",
                "second": "Doe"
            ],
            "age": 25,
            "email": "johndoe@gmail.com"
        ])

        XCTAssertEqual(person.name.first, "John")
        XCTAssertEqual(person.name.second, "Doe")
        XCTAssertEqual(person.age, 25)
        XCTAssertEqual(person.email, "johndoe@gmail.com")
    }
}
