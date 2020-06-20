import Foundation
import XMLCoder
#if canImport(CoreGraphics)
import CoreGraphics
#endif

/// SVG basic shape used to create a line connecting two points.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/line)
/// | [W3](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/line)
public class Line: Element {
    
    /// Defines the x-axis coordinate of the line starting point.
    public var x1: CGFloat = 0.0
    /// Defines the x-axis coordinate of the line ending point.
    public var y1: CGFloat = 0.0
    /// Defines the y-axis coordinate of the line starting point.
    public var x2: CGFloat = 0.0
    /// Defines the y-axis coordinate of the line ending point.
    public var y2: CGFloat = 0.0
    
    enum CodingKeys: String, CodingKey {
        case x1
        case y1
        case x2
        case y2
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
        self.init()
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        x1 = try container.decodeIfPresent(CGFloat.self, forKey: .x1) ?? 0.0
        y1 = try container.decodeIfPresent(CGFloat.self, forKey: .y1) ?? 0.0
        x2 = try container.decodeIfPresent(CGFloat.self, forKey: .x2) ?? 0.0
        y2 = try container.decodeIfPresent(CGFloat.self, forKey: .y2) ?? 0.0
    }
    
    // MARK: - CustomStringConvertible
    public override var description: String {
        let desc = "<line x1=\"\(x1)\", y1=\"\(y1)\", x2=\"\(x2)\", y2=\"\(y2)\""
        return desc + " \(super.description) />"
    }
}

// MARK: - DynamicNodeEncoding
extension Line: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Line: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}

// MARK: - CommandRepresentable
extension Line: CommandRepresentable {
    public func commands() throws -> [Path.Command] {
        return [
            .moveTo(point: CGPoint(x: x1, y: y1)),
            .lineTo(point: CGPoint(x: x2, y: y2)),
            .lineTo(point: CGPoint(x: x1, y: y1)),
            .closePath
        ]
    }
}
