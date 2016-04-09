import XCTest
@testable import Decodable

class DecoderTests: XCTestCase {
    func testDecodingString() throws {
        let decoder = Decoder(json: ["string": "Decoded"])
        let result: String = try decoder.value(forKey: "string")
        XCTAssertEqual(result, "Decoded")
    }

    func testDecodingInt() throws {
        let decoder = Decoder(json: ["integer": 1])
        let result: Int = try decoder.value(forKey: "integer")
        XCTAssertEqual(result, 1)
    }

    func testDecodingMissingKey() {
        let decoder = Decoder(json: [:])
        XCTAssertThrowsError(try decoder.value(forKey: "string") as String) { error in
            switch error {
            case Decoder.Error.missingKey(let key):
                XCTAssertEqual(key, "string")
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testDecodingWrongType() {
        let decoder = Decoder(json: ["string": "Decoded"])
        XCTAssertThrowsError(try decoder.value(forKey: "string") as Int) { error in
            switch error {
            case let Decoder.Error.wrongType(key, _, _):
                XCTAssertEqual(key, "string")
                // FIXME: Properly test types returned.
//                XCTAssertEqual(String(expected), String(Int.self))
//                XCTAssertEqual(String(actual), String(String.self))
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testDecodingURL() throws {
        let decoder = Decoder(json: ["url": "http://apple.com"])
        let result: NSURL = try decoder.value(forKey: "url")
        XCTAssertEqual(result.absoluteString, "http://apple.com")
    }

    func testDecodingInvalidURL() {
        let decoder = Decoder(json: ["url": "£"])
        XCTAssertThrowsError(try decoder.value(forKey: "url") as NSURL) { error in
            switch error {
            case let Decoder.Error.invalidURL(key, stringValue):
                XCTAssertEqual(key, "url")
                XCTAssertEqual(stringValue, "£")
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testDecodingDate() throws {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss"

        let decoder = Decoder(json: ["date": formatter.string(from: date)])
        let result: NSDate = try decoder.value(forKey: "date", formatter: formatter)
        XCTAssertEqual(formatter.string(from: result), formatter.string(from: date))
    }

    func testDecodingInvalidDate() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .longStyle

        let decoder = Decoder(json: ["date": "12:00 PM"])
        XCTAssertThrowsError(try decoder.value(forKey: "date", formatter: formatter) as NSDate) { error in
            switch error {
            case let Decoder.Error.invalidDate(key, stringValue, formatter):
                XCTAssertEqual(key, "date")
                XCTAssertEqual(stringValue, "12:00 PM")
                XCTAssertEqual(formatter, formatter)
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testDecodingDecodable() throws {
        let decoder = Decoder(json: ["person": [
            "name": [
                "first": "John",
                "second": "Doe"
            ],
            "age": 25,
            "email": "johndoe@gmail.com"
        ]])

        let person: Person = try decoder.value(forKey: "person")
        XCTAssertEqual(person.name.first, "John")
        XCTAssertEqual(person.name.second, "Doe")
        XCTAssertEqual(person.age, 25)
        XCTAssertEqual(person.email, "johndoe@gmail.com")
    }

    func testDecodingDecodableMissingKey() {
        let decoder = Decoder(json: ["person": [:]])
        XCTAssertThrowsError(try decoder.value(forKey: "person") as Person) { error in
            switch error {
            case let Decoder.Error.missingKey(key):
                XCTAssertEqual(key, "person.name")
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testDecodingDecodableWrongType() {
        let decoder = Decoder(json: ["person": ["name": "John Doe"]])
        XCTAssertThrowsError(try decoder.value(forKey: "person") as Person) { error in
            switch error {
            case let Decoder.Error.wrongType(key, _, _):
                XCTAssertEqual(key, "person.name")
                // FIXME: Properly test types returned.
//                XCTAssertEqual(String(expected), String(Person.self))
//                XCTAssertEqual(String(actual), String(String.self))
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testDecodingOptionalString() throws {
        let decoder = Decoder(json: ["string": "Decoded"])
        let result: String? = try decoder.optionalValue(forKey: "string")
        XCTAssertEqual(result, "Decoded")
    }

    func testDecodingOptionalMissingKey() throws {
        let decoder = Decoder(json: [:])
        let result: String? = try decoder.optionalValue(forKey: "string")
        XCTAssertNil(result)
    }

    func testDecodingOptionalWrongType() {
        let decoder = Decoder(json: ["string": "Decoded"])
        XCTAssertThrowsError(try decoder.optionalValue(forKey: "string") as Int?) { error in
            switch error {
            case let Decoder.Error.wrongType(key, _, _):
                XCTAssertEqual(key, "string")
                // FIXME: Properly test types returned.
//                XCTAssertEqual(String(expected), String(Int.self))
//                XCTAssertEqual(String(actual), String(String.self))
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }
}
