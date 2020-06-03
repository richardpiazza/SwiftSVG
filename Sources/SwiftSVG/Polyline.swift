import Foundation
import XMLCoder

/// SVG basic shape that creates straight lines connecting several points.
///
/// Typically a polyline is used to create open shapes as the last point doesn't have to be connected to the first
/// point. For closed shapes see the `Polygon` element.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/polyline)
/// | [W3](https://www.w3.org/TR/SVG11/shapes.html#PolylineElement)
public class Polyline: Element {
    
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
        return "<polyline points=\"\(points)\" \(super.description) />"
    }
}

// MARK: - DynamicNodeEncoding
extension Polyline: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Polyline: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}
