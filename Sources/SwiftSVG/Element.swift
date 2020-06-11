import Foundation
import XMLCoder

/// Base class for all SVG elements
public class Element: Codable, CustomStringConvertible,
    CoreAttributes, PresentationAttributes, StylingAttributes {
    
    public enum CodingKeys: String, CodingKey {
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
    
    public init() {
        
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        var components: [String] = []
        if !coreDescription.isEmpty {
            components.append(coreDescription)
        }
        if !presentationDescription.isEmpty {
            components.append(presentationDescription)
        }
        if !stylingDescription.isEmpty {
            components.append(stylingDescription)
        }
        
        return components.joined(separator: " ")
    }
}

public extension CommandRepresentable where Self: Element {
    /// When a `Path` is accessed on an element, the path that is returned should have the supplied transformations
    /// applied.
    ///
    /// For instance, if
    /// * a `Path.data` contains relative elements,
    /// * and `transformations` contains a `.translate`
    ///
    /// Than the path created will not only use 'absolute' instructions, but those instructions will be modified to
    /// include the required transformation.
    func path(applying transformations: [Transformation]) throws -> Path {
        var _transformations = transformations
        _transformations.append(contentsOf: self.transformations)
        
        let commands = try self.commands().map({ $0.applying(transformations: _transformations) })
        
        let path = Path(commands: commands)
        path.fillColor = fillColor
        path.fillOpacity = fillOpacity
        path.strokeColor = strokeColor
        path.strokeOpacity = strokeOpacity
        path.strokeWidth = strokeWidth
        
        return path
    }
}
