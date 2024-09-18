import Swift2D

public struct Fill {
    public struct Default {
        public static let color = "black"
        public static let opacity = 1.0
        public static let rule = Rule.nonZero
    }

    public var color: String
    public var opacity: Double
    public var rule: Rule

    /// Initialize aggregate data related to a `Fill`.
    ///
    /// Any supplied `nil` values are replaced with the corresponding value from `Fill.Default`
    ///
    /// - parameters:
    ///   - color: Name of or hexadecimal value used to color the fill.
    ///   - opacity: The level of opaqueness given applied to the color.
    ///   - rule: Algorithm used to determine the inside of the shape.
    public init(color: String?, opacity: Double?, rule: Rule?) {
        self.color = color ?? Fill.Default.color
        self.opacity = opacity ?? Fill.Default.opacity
        self.rule = rule ?? Fill.Default.rule
    }

    public init() {
        self.init(color: nil,
                  opacity: nil,
                  rule: nil)
    }

    /// Presentation attribute defining the algorithm to use to determine the inside part of a shape.
    ///
    /// The default `Rule` is `.nonzero`.
    public enum Rule: String, Codable, CaseIterable {
        /// The value evenodd determines the "insideness" of a point in the shape by drawing a ray from that point to
        /// infinity in any direction and counting the number of path segments from the given shape that the ray
        /// crosses. If this number is odd, the point is inside; if even, the point is outside.
        case evenOdd = "evenodd"
        /// The value nonzero determines the "insideness" of a point in the shape by drawing a ray from that point to
        /// infinity in any direction, and then examining the places where a segment of the shape crosses the ray.
        /// Starting with a count of zero, add one each time a path segment crosses the ray from left to right and
        /// subtract one each time a path segment crosses the ray from right to left. After counting the crossings, if
        /// the result is zero then the point is outside the path. Otherwise, it is inside.
        case nonZero = "nonzero"
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            guard let rule = Rule(rawValue: rawValue) else {
                print("Attempts to decode Fill.Rule with rawValue: '\(rawValue)'")
                self = .nonZero
                return
            }
            
            self = rule
        }
    }
}

extension Fill.Rule: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}
