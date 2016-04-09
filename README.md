# SwiftDecodable

_TODO_

## Usage

Allow a struct or class to be decoded by making it conform to the `Decodable` protocol.

```swift
struct Person {
    let name: String
    let age: Int
}

extension Person: Decodable {
    init(decoder: Decoder) throws {
        self.name = try decoder.decode("name")
        self.age = try decoder.decode("age")
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
