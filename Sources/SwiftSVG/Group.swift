import Foundation
import XMLCoder

/// A container used to group other SVG elements.
///
/// Grouping constructs, when used in conjunction with the ‘desc’ and ‘title’ elements, provide information
/// about document structure and semantics.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/g)
/// | [W3](https://www.w3.org/TR/SVG11/struct.html#Groups)
public class Group: Element {
    
    public var circles: [Circle]?
    public var groups: [Group]?
    public var lines: [Line]?
    public var paths: [Path]?
    public var polygons: [Polygon]?
    public var polylines: [Polyline]?
    public var rectangles: [Rectangle]?
    public var texts: [Text]?
    
    enum CodingKeys: String, CodingKey {
        case circles = "circle"
        case groups = "g"
        case lines = "line"
        case paths = "path"
        case polylines = "polyline"
        case polygons = "polygon"
        case rectangles = "rect"
        case texts = "text"
    }
    
    public override init() {
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        circles = try container.decodeIfPresent([Circle].self, forKey: .circles)
        groups = try container.decodeIfPresent([Group].self, forKey: .groups)
        lines = try container.decodeIfPresent([Line].self, forKey: .lines)
        paths = try container.decodeIfPresent([Path].self, forKey: .paths)
        polygons = try container.decodeIfPresent([Polygon].self, forKey: .polygons)
        polylines = try container.decodeIfPresent([Polyline].self, forKey: .polylines)
        rectangles = try container.decodeIfPresent([Rectangle].self, forKey: .rectangles)
        texts = try container.decodeIfPresent([Text].self, forKey: .texts)
    }
    
    // MARK: - CustomStringConvertible
    public override var description: String {
        var contents: String = ""
        
        let circles = self.circles?.compactMap({ $0.description }) ?? []
        circles.forEach({ contents.append("\n\($0)") })
        
        let groups = self.groups?.compactMap({ $0.description }) ?? []
        groups.forEach({ contents.append("\n\($0)") })
        
        let lines = self.lines?.compactMap({ $0.description }) ?? []
        lines.forEach({ contents.append("\n\($0)") })
        
        let paths = self.paths?.compactMap({ $0.description }) ?? []
        paths.forEach({ contents.append("\n\($0)") })
        
        let polylines = self.polylines?.compactMap({ $0.description }) ?? []
        polylines.forEach({ contents.append("\n\($0)") })
        
        let polygons = self.polygons?.compactMap({ $0.description }) ?? []
        polygons.forEach({ contents.append("\n\($0)") })
        
        let rectangles = self.rectangles?.compactMap({ $0.description }) ?? []
        rectangles.forEach({ contents.append("\n\($0)") })
        
        let texts = self.texts?.compactMap({ $0.description }) ?? []
        texts.forEach({ contents.append("\n\($0)") })
        
        return "<g \(super.description) >\(contents)\n</g>"
    }
}

// MARK: - DynamicNodeEncoding
extension Group: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        guard let _ = key as? CodingKeys else {
            return .attribute
        }
        
        return .element
    }
}

// MARK: - DynamicNodeDecoding
extension Group: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        guard let _ = key as? CodingKeys else {
            return .attribute
        }
        
        return .element
    }
}

// MARK: - Paths
public extension Group {
    /// A representation of all the sub-`Path`s in the `Group`.
    func subpaths(applying transformations: [Transformation] = []) throws -> [Path] {
        var _transformations = transformations
        _transformations.append(contentsOf: self.transformations)
        
        var output: [Path] = []
        
        if let circles = self.circles {
            try output.append(contentsOf: circles.compactMap({ try $0.path(applying: _transformations) }))
        }
        
        if let rectangles = self.rectangles {
            try output.append(contentsOf: rectangles.compactMap({ try $0.path(applying: _transformations) }))
        }
        
        if let polygons = self.polygons {
            try output.append(contentsOf: polygons.compactMap({ try $0.path(applying: _transformations) }))
        }
        
        if let polylines = self.polylines {
            try output.append(contentsOf: polylines.compactMap({ try $0.path(applying: _transformations) }))
        }
        
        if let paths = self.paths {
            try output.append(contentsOf: paths.map({ try $0.path(applying: _transformations) }))
        }
        
        if let groups = self.groups {
            try groups.forEach({
                try output.append(contentsOf: $0.subpaths(applying: _transformations))
            })
        }
        
        return output
    }
}
