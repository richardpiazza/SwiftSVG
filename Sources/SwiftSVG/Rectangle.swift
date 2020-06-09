import Foundation
import XMLCoder

/// Basic SVG shape that draws rectangles, defined by their position, width, and height.
///
/// The values used for the x- and y-axis rounded corner radii are determined implicitly
/// if the ‘rx’ or ‘ry’ attributes (or both) are not specified, or are specified but with invalid values.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/rect)
/// | [W3](https://www.w3.org/TR/SVG11/shapes.html#RectElement)
public class Rectangle: Element {
    
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
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
        case width
        case height
        case rx
        case ry
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(x: Float, y: Float, width: Float, height: Float, rx: Float? = nil, ry: Float? = nil) {
        self.init()
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rx = rx
        self.ry = ry
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        x = try container.decodeIfPresent(Float.self, forKey: .x) ?? 0.0
        y = try container.decodeIfPresent(Float.self, forKey: .y) ?? 0.0
        width = try container.decodeIfPresent(Float.self, forKey: .width) ?? 0.0
        height = try container.decodeIfPresent(Float.self, forKey: .height) ?? 0.0
        rx = try container.decodeIfPresent(Float.self, forKey: .rx)
        ry = try container.decodeIfPresent(Float.self, forKey: .ry)
    }
    
    // MARK: - CustomStringConvertible
    public override var description: String {
        var desc = String(format: "<rect x=\"%.5f\" y=\"%.5f\" width=\"%.5f\" height=\"%.5f\"", x, y, width, height)
        if let rx = self.rx {
            desc.append(String(format: " rx=\"%.5f\"", rx))
        }
        if let ry = self.ry {
            desc.append(String(format: " ry=\"%.5f\"", ry))
        }
        
        return desc + " \(super.description) />"
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
