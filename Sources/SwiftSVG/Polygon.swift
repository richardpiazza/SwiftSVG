import Foundation
import XMLCoder

/// Defines a closed shape consisting of a set of connected straight line segments.
///
/// The last point is connected to the first point. For open shapes, see the `Polyline` element. If an odd number of
/// coordinates is provided, then the element is in error.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/polygon)
/// | [W3](https://www.w3.org/TR/SVG11/shapes.html#PolygonElement)
public class Polygon: Element {
    
    /// The points that make up the polygon.
    public var points: String = ""
    
    enum CodingKeys: String, CodingKey {
        case points
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(points: String) {
        self.init()
        self.points = points
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        points = try container.decodeIfPresent(String.self, forKey: .points) ?? ""
    }
    
    // MARK: - CustomStringConvertible
    public override var description: String {
        return "<polygon points=\"\(points)\" \(super.description) />"
    }
}

// MARK: - DynamicNodeEncoding
extension Polygon: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Polygon: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}

// MARK: - CommandRepresentable
extension Polygon: CommandRepresentable {
    public func commands() throws -> [Path.Command] {
        return try PolygonProcessor(points: points).commands()
    }
}
