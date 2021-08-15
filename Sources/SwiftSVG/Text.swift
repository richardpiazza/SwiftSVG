import XMLCoder

/// Graphics element consisting of text
///
/// It's possible to apply a gradient, pattern, clipping path, mask, or filter to `Text`, like any other SVG graphics element.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/text)
/// | [W3](https://www.w3.org/TR/SVG11/text.html#TextElement)
public struct Text: Element {
    
    public var value: String = ""
    public var x: Double?
    public var y: Double?
    public var dx: Double?
    public var dy: Double?
    
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
        case value = ""
        case x
        case y
        case dx
        case dy
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
    
    public init(value: String) {
        self.value = value
    }
    
    public var description: String {
        var components: [String] = []
        
        if let x = self.x, !x.isNaN && !x.isZero {
            components.append(String(format: "x=\"%.5f\"", x))
        }
        if let y = self.y, !y.isNaN && !y.isZero {
            components.append(String(format: "y=\"%.5f\"", y))
        }
        if let dx = self.dx, !dx.isNaN, !dx.isZero {
            components.append(String(format: "dx=\"%.5f\"", dx))
        }
        if let dy = self.dy, !dy.isNaN, !dy.isZero {
            components.append(String(format: "dy=\"%.5f\"", dy))
        }
        
        components.append(attributeDescription)
        
        return "<text " + components.joined(separator: " ") + " >\(value)</text>"
    }
}

// MARK: - DynamicNodeEncoding
extension Text: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case CodingKeys.value:
            return .element
        default:
            return .attribute
        }
    }
}

// MARK: - DynamicNodeDecoding
extension Text: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.value:
            return .element
        default:
            return .attribute
        }
    }
}
