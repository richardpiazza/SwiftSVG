# SwiftSVG
A foundation-based SVG parsing library

<p>
  <img src="https://github.com/richardpiazza/SwiftSVG/workflows/Swift/badge.svg?branch=master" />
  <img src="https://img.shields.io/badge/Swift-5.2-orange.svg" />
  <a href="https://swift.org/package-manager">
    <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
  </a>
  <a href="https://twitter.com/richardpiazza">
    <img src="https://img.shields.io/badge/twitter-@richardpiazza-blue.svg?style=flat" alt="Twitter: @richardpiazza" />
  </a>
</p>

## Usage

**SwiftSVG** is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/richardpiazza/SwiftSVG.git", from: "0.6.0")
    ],
    ...
)
```

Then import the **SwiftSVG** packages wherever you'd like to use it:

```swift
import SwiftSVG
```
