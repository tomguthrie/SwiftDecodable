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

    func testDecodesPersonMissingEmail() throws {
        let person = try Person(json: [
            "name": [
                "first": "John",
                "second": "Doe"
            ],
            "age": 25,
        ])

        XCTAssertEqual(person.name.first, "John")
        XCTAssertEqual(person.name.second, "Doe")
        XCTAssertEqual(person.age, 25)
        XCTAssertNil(person.email)
    }

    func testDecodesFromData() throws {
        let data = try JSONSerialization.data(withJSONObject: [
            "name": [
                "first": "John",
                "second": "Doe"
            ],
            "age": 25,
            "email": "johndoe@gmail.com"
        ], options: [])

        let person = try Person(data: data)
        XCTAssertEqual(person.name.first, "John")
        XCTAssertEqual(person.name.second, "Doe")
        XCTAssertEqual(person.age, 25)
        XCTAssertEqual(person.email, "johndoe@gmail.com")
    }
}
