import Foundation
import XMLCoder
#if canImport(CoreGraphics)
import CoreGraphics
#endif

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
    public var x: CGFloat = 0.0
    /// The y-axis coordinate of the side of the rectangle which
    /// has the smaller y-axis coordinate value
    public var y: CGFloat = 0.0
    /// The width of the rectangle.
    public var width: CGFloat = 0.0
    /// The height of the rectangle.
    public var height: CGFloat = 0.0
    /// For rounded rectangles, the x-axis radius of the ellipse used
    /// to round off the corners of the rectangle.
    public var rx: CGFloat?
    /// For rounded rectangles, the y-axis radius of the ellipse used
    /// to round off the corners of the rectangle.
    public var ry: CGFloat?
    
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
    
    public convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, rx: CGFloat? = nil, ry: CGFloat? = nil) {
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
        x = try container.decodeIfPresent(CGFloat.self, forKey: .x) ?? 0.0
        y = try container.decodeIfPresent(CGFloat.self, forKey: .y) ?? 0.0
        width = try container.decodeIfPresent(CGFloat.self, forKey: .width) ?? 0.0
        height = try container.decodeIfPresent(CGFloat.self, forKey: .height) ?? 0.0
        rx = try container.decodeIfPresent(CGFloat.self, forKey: .rx)
        ry = try container.decodeIfPresent(CGFloat.self, forKey: .ry)
    }
    
    // MARK: - CustomStringConvertible
    public override var description: String {
        var desc = "<rect x=\"\(x)\" y=\"\(y)\" width=\"\(width)\" height=\"\(height)\""
        if let rx = self.rx {
            desc.append(" rx=\"\(rx)\"")
        }
        if let ry = self.ry {
            desc.append(" ry=\"\(ry)\"")
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
