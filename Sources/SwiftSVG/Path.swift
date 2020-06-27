import XMLCoder

/// Generic element to define a shape.
///
/// A path is defined by including a ‘path’ element in a SVG document which contains a **d="(path data)"**
/// attribute, where the **‘d’** attribute contains the moveto, line, curve (both Cubic and Quadratic Bézier),
/// arc and closepath instructions.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/path)
/// | [W3](https://www.w3.org/TR/SVG11/paths.html)
public struct Path: Element {
    
    /// The definition of the outline of a shape.
    public var data: String = ""
    
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
        case data = "d"
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
    
    public init(data: String) {
        self.init()
        self.data = data
    }
    
    public init(commands: [Path.Command]) {
        self.init()
        data = commands.map({ $0.description }).joined()
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        return "<path d=\"\(data)\" \(attributeDescription) />"
    }
}

// MARK: - DynamicNodeEncoding
extension Path: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Path: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}

// MARK: - CommandRepresentable
extension Path: CommandRepresentable {
    public func commands() throws -> [Command] {
        return try PathProcessor(data: data).commands()
    }
}

// MARK: - Equatable
extension Path: Equatable {
    public static func == (lhs: Path, rhs: Path) -> Bool {
        do {
            let lhsCommands = try lhs.commands()
            let rhsCommands = try rhs.commands()
            return lhsCommands == rhsCommands
        } catch {
            return false
        }
    }
}
