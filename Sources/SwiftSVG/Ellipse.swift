import Foundation
import XMLCoder

/// SVG basic shape, used to create ellipses based on a center coordinate, and both their x and y radius.
///
/// The arc of an ‘ellipse’ element begins at the "3 o'clock" point on the radius and progresses towards the
/// "9 o'clock" point. The starting point and direction of the arc are affected by the user space transform in the same
/// manner as the geometry of the element.
public class Ellipse: Element {
    
    /// The x position of the ellipse.
    public var x: Float = 0.0
    /// The y position of the ellipse.
    public var y: Float = 0.0
    /// The radius of the ellipse on the x axis.
    public var rx: Float = 0.0
    /// The radius of the ellipse on the y axis.
    public var ry: Float = 0.0
    
    enum CodingKeys: String, CodingKey {
        case x = "cx"
        case y = "cy"
        case rx
        case ry
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(x: Float, y: Float, rx: Float, ry: Float) {
        self.init()
        self.x = x
        self.y = y
        self.rx = rx
        self.ry = ry
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        x = try container.decodeIfPresent(Float.self, forKey: .x) ?? 0.0
        y = try container.decodeIfPresent(Float.self, forKey: .y) ?? 0.0
        rx = try container.decodeIfPresent(Float.self, forKey: .rx) ?? 0.0
        ry = try container.decodeIfPresent(Float.self, forKey: .ry) ?? 0.0
    }
    
    // MARK: - CustomStringConvertible
    public override var description: String {
        let desc = String(format: "<ellipse cx=\"%.5f\" cy=\"%.5f\" rx=\"%.5f\", ry=\"%.5f\"", x, y, rx, ry)
        return desc + " \(super.description) />"
    }
}

// MARK: - DynamicNodeEncoding
extension Ellipse: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Ellipse: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}

// MARK: - DirectionalCommandRepresentable
extension Ellipse: DirectionalCommandRepresentable {
    public func commands(clockwise: Bool) throws -> [Path.Command] {
        return EllipseProcessor(ellipse: self).commands(clockwise: clockwise)
    }
}
