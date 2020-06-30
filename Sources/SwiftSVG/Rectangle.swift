import Swift2D
import XMLCoder

/// Basic SVG shape that draws rectangles, defined by their position, width, and height.
///
/// The values used for the x- and y-axis rounded corner radii are determined implicitly
/// if the ‘rx’ or ‘ry’ attributes (or both) are not specified, or are specified but with invalid values.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/rect)
/// | [W3](https://www.w3.org/TR/SVG11/shapes.html#RectElement)
public struct Rectangle: Element {
    
    /// The x-axis coordinate of the side of the rectangle which
    /// has the smaller x-axis coordinate value.
    public var x: Float = 0.0
    /// The y-axis coordinate of the side of the rectangle which
    /// has the smaller y-axis coordinate value
    public var y: Float = 0.0
    /// The width of the rectangle.
    public var width: Float = 0.0
    /// The height of the rectangle.
    public var height: Float = 0.0
    /// For rounded rectangles, the x-axis radius of the ellipse used
    /// to round off the corners of the rectangle.
    public var rx: Float?
    /// For rounded rectangles, the y-axis radius of the ellipse used
    /// to round off the corners of the rectangle.
    public var ry: Float?
    
    // CoreAttributes
    public var id: String?
    
    // PresentationAttributes
    public var fillColor: String?
    public var fillOpacity: Float?
    public var fillRule: Fill.Rule?
    public var strokeColor: String?
    public var strokeWidth: Float?
    public var strokeOpacity: Float?
    public var strokeLineCap: Stroke.LineCap?
    public var strokeLineJoin: Stroke.LineJoin?
    public var strokeMiterLimit: Float?
    public var transform: String?
    
    // StylingAttributes
    public var style: String?
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
        case width
        case height
        case rx
        case ry
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
    
    public init(x: Float, y: Float, width: Float, height: Float, rx: Float? = nil, ry: Float? = nil) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rx = rx
        self.ry = ry
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        var desc = "<rect x=\"\(x)\" y=\"\(y)\" width=\"\(width)\" height=\"\(height)\""
        if let rx = self.rx {
            desc.append(" rx=\"\(rx)\"")
        }
        if let ry = self.ry {
            desc.append(" ry=\"\(ry)\"")
        }
        
        return desc + " \(attributeDescription) />"
    }
}

// MARK: - DynamicNodeEncoding
extension Rectangle: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Rectangle: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}

// MARK: - DirectionalCommandRepresentable
extension Rectangle: DirectionalCommandRepresentable {
    public func commands(clockwise: Bool) throws -> [Path.Command] {
        return RectangleProcessor(rectangle: self).commands(clockwise: clockwise)
    }
}
