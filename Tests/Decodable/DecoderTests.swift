import XCTest
@testable import Decodable

class DecoderTests: XCTestCase {
    func testDecodingString() throws {
        let decoder = Decoder(json: ["string": "Decoded"])
        let result: String = try decoder.decode("string")
        XCTAssertEqual(result, "Decoded")
    }

    func testDecodingInt() throws {
        let decoder = Decoder(json: ["integer": 1])
        let result: Int = try decoder.decode("integer")
        XCTAssertEqual(result, 1)
    }

    func testDecodingMissingKey() {
        let decoder = Decoder(json: [:])
        XCTAssertThrowsError(try decoder.decode("string") as String) { error in
            switch error {
            case Decoder.Error.MissingKey(let key):
                XCTAssertEqual(key, "string")
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }

    func testDecodingWrongType() {
        let decoder = Decoder(json: ["string": "Decoded"])
        XCTAssertThrowsError(try decoder.decode("string") as Int) { error in
            switch error {
            case let Decoder.Error.WrongType(key, _, _):
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
        let result: NSURL = try decoder.decode("url")
        XCTAssertEqual(result.absoluteString, "http://apple.com")
    }

    func testDecodingInvalidURL() {
        let decoder = Decoder(json: ["url": "£"])
        XCTAssertThrowsError(try decoder.decode("url") as NSURL) { error in
            switch error {
            case let Decoder.Error.InvalidURL(key, stringValue):
                XCTAssertEqual(key, "url")
                XCTAssertEqual(stringValue, "£")
            default:
                XCTFail("Wrong error thrown")
            }
        }
    }
}
