import Foundation

public protocol StylingAttributes {
    var style: String? { get set }
}

public extension StylingAttributes {
    var stylingDescription: String {
        if let style = self.style {
            return "\(Element.CodingKeys.style.rawValue)=\"\(style)\""
        } else {
            return ""
        }
    }
}
