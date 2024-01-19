import Swift2D
import XMLCoder

/// SVG basic shape, used to create ellipses based on a center coordinate, and both their x and y radius.
///
/// The arc of an ‘ellipse’ element begins at the "3 o'clock" point on the radius and progresses towards the
/// "9 o'clock" point. The starting point and direction of the arc are affected by the user space transform in the same
/// manner as the geometry of the element.
public struct Ellipse: Element {
    
    /// The x position of the ellipse.
    public var x: Double = 0.0
    /// The y position of the ellipse.
    public var y: Double = 0.0
    /// The radius of the ellipse on the x axis.
    public var rx: Double = 0.0
    /// The radius of the ellipse on the y axis.
    public var ry: Double = 0.0
    
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
        case x = "cx"
        case y = "cy"
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
    
    public init(x: Double, y: Double, rx: Double, ry: Double) {
        self.x = x
        self.y = y
        self.rx = rx
        self.ry = ry
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        let desc = "<ellipse cx=\"\(x)\" cy=\"\(y)\" rx=\"\(rx)\" ry=\"\(ry)\""
        return desc + " \(attributeDescription) />"
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
