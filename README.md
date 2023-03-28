# SwiftSVG

A Swift SVG parsing library

![](https://github.com/richardpiazza/SwiftSVG/workflows/Swift/badge.svg?branch=main)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frichardpiazza%2FSwiftSVG%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/richardpiazza/SwiftSVG)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frichardpiazza%2FSwiftSVG%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/richardpiazza/SwiftSVG)

## Usage

**SwiftSVG** is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/richardpiazza/SwiftSVG.git", from: "0.10.0")
    ],
    ...
)
```

Then import the **SwiftSVG** packages wherever you'd like to use it:

```swift
import SwiftSVG
```

## Features

SVG (Scalable Vector Graphics) is an XML-based markup language for describing two-dimensional vector graphics.
The text-based files contain a series of shapes and paths forming images.
**SwiftSVG** parses & builds SVG files so the data can be interpreted and used. (For instance: [VectorPlus](https://github.com/richardpiazza/VectorPlus))

An `SVG` is most commonly initialized using an existing file (`URL`) or `Data`.

```swift
let url: URL
let svg1 = try SVG.make(from: url)

let data: Data
let svg2 = try SVG.make(with: data)
```

## Contributions

Checkout

* [Contributor Guide](https://github.com/richardpiazza/.github/blob/main/CONTRIBUTING.md)

* [Code of Conduct](https://github.com/richardpiazza/.github/blob/main/CODE_OF_CONDUCT.md)

* [Swift Style Guide](https://github.com/richardpiazza/.github/blob/main/SWIFT_STYLE_GUIDE.md)

## License

This project is released under an [MIT License](https://github.com/richardpiazza/SwiftSVG/blob/master/LICENSE).
