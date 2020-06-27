public protocol StylingAttributes {
    var style: String? { get set }
}

internal enum StylingAttributesKeys: String, CodingKey {
    case style
}

public extension StylingAttributes {
    var stylingDescription: String {
        if let style = self.style {
            return "\(StylingAttributesKeys.style.rawValue)=\"\(style)\""
        } else {
            return ""
        }
    }
}
