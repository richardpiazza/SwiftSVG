import Foundation
import XMLCoder
#if canImport(CoreGraphics)
import CoreGraphics
#endif

/// Basic shape, used to draw circles based on a center point and a radius.
///
/// The arc of a ‘circle’ element begins at the "3 o'clock" point on the radius and progresses towards the
/// "9 o'clock" point. The starting point and direction of the arc are affected by the user space transform
/// in the same manner as the geometry of the element.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/circle)
/// | [W3](https://www.w3.org/TR/SVG11/shapes.html#CircleElement)
public class Circle: Element {
    
    /// The x-axis coordinate of the center of the circle.
    public var x: CGFloat = 0.0
    /// The y-axis coordinate of the center of the circle.
    public var y: CGFloat = 0.0
    /// The radius of the circle.
    public var r: CGFloat = 0.0
    
    enum CodingKeys: String, CodingKey {
        case x = "cx"
        case y = "cy"
        case r = "r"
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(x: CGFloat, y: CGFloat, r: CGFloat) {
        self.init()
        self.x = x
        self.y = y
        self.r = r
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        x = try container.decodeIfPresent(CGFloat.self, forKey: .x) ?? 0.0
        y = try container.decodeIfPresent(CGFloat.self, forKey: .y) ?? 0.0
        r = try container.decodeIfPresent(CGFloat.self, forKey: .r) ?? 0.0
    }
    
    // MARK: - CustomStringConvertible
    public override var description: String {
        let desc = "<circle cx=\"\(x)\" cy=\"\(y)\" r=\"\(r)\""
        return desc + " \(super.description) />"
    }
}

// MARK: - DynamicNodeEncoding
extension Circle: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Circle: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}

// MARK: - DirectionalCommandRepresentable
extension Circle: DirectionalCommandRepresentable {
    public func commands(clockwise: Bool) throws -> [Path.Command] {
        return EllipseProcessor(circle: self).commands(clockwise: clockwise)
    }
}
