# SwiftDecodable

Simple decoding of JSON to Swift structs/classes without meaningless operators.

## Usage

Allow a struct or class to be decoded by making it conform to the `Decodable` protocol.

```swift
struct Person {
    let name: String
    let age: Int
}

extension Person: Decodable {
    init(decoder: Decoder) throws {
        self.name = try decoder.value(forKey: "name")
        self.age = try decoder.value(forKey: "age")
    }
}
```

Then decode it with some JSON:

```swift
let json: JSON = [
    "name": "John Doe",
    "age": 35
]
let person = Person(json: json)
```

Or straight from some JSON data:

```swift
let data: NSData = ...
let person = Person(data: data)
```

For a more complete example see [Person.swift](Tests/Decodable/Person.swift)

## License

SwiftDecodable is released under the [MIT License](LICENSE).
