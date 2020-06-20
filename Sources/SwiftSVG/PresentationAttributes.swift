import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public protocol PresentationAttributes {
    var fillColor: String? { get set }
    var fillOpacity: CGFloat? { get set }
    var fillRule: Fill.Rule? { get set }
    var strokeColor: String? { get set }
    var strokeWidth: CGFloat? { get set }
    var strokeOpacity: CGFloat? { get set }
    var strokeLineCap: Stroke.LineCap? { get set }
    var strokeLineJoin: Stroke.LineJoin? { get set }
    var strokeMiterLimit: CGFloat? { get set }
    var transform: String? { get set }
}

public extension PresentationAttributes {
    var presentationDescription: String {
        var attributes: [String] = []
        
        if let fillColor = self.fillColor {
            attributes.append("\(Element.CodingKeys.fillColor.rawValue)=\"\(fillColor)\"")
        }
        if let fillOpacity = self.fillOpacity {
            attributes.append("\(Element.CodingKeys.fillOpacity.rawValue)=\"\(fillOpacity)\"")
        }
        if let fillRule = self.fillRule {
            attributes.append("\(Element.CodingKeys.fillRule.rawValue)=\"\(fillRule.description)\"")
        }
        if let strokeColor = self.strokeColor {
            attributes.append("\(Element.CodingKeys.strokeColor.rawValue)=\"\(strokeColor)\"")
        }
        if let strokeWidth = self.strokeWidth {
            attributes.append("\(Element.CodingKeys.strokeWidth.rawValue)=\"\(strokeWidth)\"")
        }
        if let strokeOpacity = self.strokeOpacity {
            attributes.append("\(Element.CodingKeys.strokeOpacity.rawValue)=\"\(strokeOpacity)\"")
        }
        if let strokeLineCap = self.strokeLineCap {
            attributes.append("\(Element.CodingKeys.strokeLineCap.rawValue)=\"\(strokeLineCap.description)\"")
        }
        if let strokeLineJoin = self.strokeLineJoin {
            attributes.append("\(Element.CodingKeys.strokeLineJoin.rawValue)=\"\(strokeLineJoin.description)\"")
        }
        if let strokeMiterLimit = self.strokeMiterLimit {
            attributes.append("\(Element.CodingKeys.strokeMiterLimit.rawValue)=\"\(strokeMiterLimit)\"")
        }
        if let transform = self.transform {
            attributes.append("\(Element.CodingKeys.transform.rawValue)=\"\(transform)\"")
        }
        
        return attributes.joined(separator: " ")
    }
    
    var transformations: [Transformation] {
        let value = transform?.replacingOccurrences(of: " ", with: "") ?? ""
        guard !value.isEmpty else {
            return []
        }
        
        let values = value.split(separator: ")").map({ $0.appending(")") })
        return values.compactMap({ Transformation($0) })
    }
    
    var fill: Fill? {
        if fillColor == nil && fillOpacity == nil {
            return nil
        }
        
        var fill = Fill()
        fill.color = fillColor ?? "black"
        fill.opacity = fillOpacity ?? 1.0
        return fill
    }
    
    var stroke: Stroke? {
        if strokeColor == nil && strokeOpacity == nil {
            return nil
        }
        
        var stroke = Stroke()
        stroke.color = strokeColor ?? "black"
        stroke.opacity = strokeOpacity ?? 1.0
        stroke.width = strokeWidth ?? 1.0
        stroke.lineCap = strokeLineCap ?? .butt
        stroke.lineJoin = strokeLineJoin ?? .miter
        stroke.miterLimit = strokeMiterLimit
        return stroke
    }
}
