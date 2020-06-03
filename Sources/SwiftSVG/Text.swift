import Foundation
import XMLCoder

/// Graphics element consisting of text
///
/// It's possible to apply a gradient, pattern, clipping path, mask, or filter to `Text`, like any other SVG graphics element.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/text)
/// | [W3](https://www.w3.org/TR/SVG11/text.html#TextElement)
public class Text: Element {
    
    public var value: String = ""
    public var x: Float?
    public var y: Float?
    public var dx: Float?
    public var dy: Float?
    
    enum CodingKeys: String, CodingKey {
        case value = ""
        case x
        case y
        case dx
        case dy
    }
    
    public override init() {
        super.init()
    }
    
    public convenience init(value: String) {
        self.init()
        self.value = value
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
        x = try container.decodeIfPresent(Float.self, forKey: .x)
        y = try container.decodeIfPresent(Float.self, forKey: .y)
        dx = try container.decodeIfPresent(Float.self, forKey: .dx)
        dy = try container.decodeIfPresent(Float.self, forKey: .dy)
    }
    
    public override var description: String {
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
        
        components.append(super.description)
        
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
