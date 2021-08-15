import XMLCoder

/// Defines a closed shape consisting of a set of connected straight line segments.
///
/// The last point is connected to the first point. For open shapes, see the `Polyline` element. If an odd number of
/// coordinates is provided, then the element is in error.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/polygon)
/// | [W3](https://www.w3.org/TR/SVG11/shapes.html#PolygonElement)
public struct Polygon: Element {
    
    /// The points that make up the polygon.
    public var points: String = ""
    
    // CoreAttributes
    public var id: String?
    
    // PresentationAttributes
    public var fillColor: String?
    public var fillOpacity: Double?
    public var fillRule: Fill.Rule?
    public var strokeColor: String?
    public var strokeWidth: Double?
    public var strokeOpacity: Double?
    public var strokeLineCap: Stroke.LineCap?
    public var strokeLineJoin: Stroke.LineJoin?
    public var strokeMiterLimit: Double?
    public var transform: String?
    
    // StylingAttributes
    public var style: String?
    
    enum CodingKeys: String, CodingKey {
        case points
        case id
        case fillColor = "fill"
        case fillOpacity = "fill-opacity"
        case fillRule = "fill-rule"
        case strokeColor = "stroke"
        case strokeWidth = "stroke-width"
        case strokeOpacity = "stroke-opacity"
        case strokeLineCap = "stroke-linecap"
        case strokeLineJoin = "stroke-linejoin"
        case strokeMiterLimit = "stroke-miterlimit"
        case transform
        case style
    }
    
    public init() {
    }
    
    public init(points: String) {
        self.points = points
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        return "<polygon points=\"\(points)\" \(attributeDescription) />"
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
