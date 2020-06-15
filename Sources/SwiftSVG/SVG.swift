import Foundation
import XMLCoder

/// SVG is a language for describing two-dimensional graphics in XML.
///
/// The svg element is a container that defines a new coordinate system and viewport. It is used as the outermost
/// element of SVG documents, but it can also be used to embed a SVG fragment inside an SVG or HTML document.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/svg)
/// | [W3](https://www.w3.org/TR/SVG11/)
public class SVG: Codable {
    
    public var viewBox: String?
    public var width: String?
    public var height: String?
    public var title: String?
    public var desc: String?
    public var circles: [Circle]?
    public var ellipses: [Ellipse]?
    public var groups: [Group]?
    public var lines: [Line]?
    public var paths: [Path]?
    public var polygons: [Polygon]?
    public var polylines: [Polyline]?
    public var rectangles: [Rectangle]?
    public var texts: [Text]?
    
    /// A non-optional, non-spaced representation of the `title`.
    public var name: String {
        let name = title ?? "SVG Document"
        let newTitle = name.components(separatedBy: .punctuationCharacters).joined(separator: "_")
        return newTitle.replacingOccurrences(of: " ", with: "_")
    }
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case viewBox
        case title
        case desc
        case circles = "circle"
        case ellipses = "ellipse"
        case groups = "g"
        case lines = "line"
        case paths = "path"
        case polylines = "polyline"
        case polygons = "polygon"
        case rectangles = "rect"
        case texts = "text"
    }
    
    public init() {
    }
    
    public convenience init(width: Int, height: Int) {
        self.init()
        self.width = "\(width)px"
        self.height = "\(height)px"
        viewBox = "0 0 \(width) \(height)"
    }
}

// MARK: - CustomStringConvertible
extension SVG: CustomStringConvertible {
    public var description: String {
        var contents: String = ""
        
        if let title = self.title {
            contents.append("\n<title>\(title)</title>")
        }
        
        if let desc = self.desc {
            contents.append("\n<desc>\(desc)</desc>")
        }
        
        let circles = self.circles?.compactMap({ $0.description }) ?? []
        circles.forEach({ contents.append("\n\($0)") })
        
        let ellipses = self.ellipses?.compactMap({ $0.description }) ?? []
        ellipses.forEach({ contents.append("\n\($0)") })
        
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
        
        return "<svg viewBox=\"\(viewBox ?? "")\" width=\"\(width ?? "")\" height=\"\(height ?? "")\">\(contents)\n</svg>"
    }
}

// MARK: - DynamicNodeEncoding
extension SVG: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case CodingKeys.width, CodingKeys.height, CodingKeys.viewBox:
            return .attribute
        default:
            return .element
        }
    }
}

// MARK: - DynamicNodeDecoding
extension SVG: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.width, CodingKeys.height, CodingKeys.viewBox:
            return .attribute
        default:
            return .element
        }
    }
}

// MARK: - Creation
public extension SVG {
    static func make(from url: URL) throws -> SVG {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw CocoaError(.fileNoSuchFile)
        }
        
        let data = try Data(contentsOf: url)
        return try make(with: data)
    }
    
    static func make(with data: Data, decoder: XMLDecoder = XMLDecoder()) throws -> SVG {
        return try decoder.decode(SVG.self, from: data)
    }
}

// MARK: - Paths
public extension SVG {
    /// A collection of all `Path`s in the document.
    func subpaths() throws -> [Path] {
        var output: [Path] = []
        let _transformations: [Transformation] = []
        
        if let circles = self.circles {
            try output.append(contentsOf: circles.compactMap({ try $0.path(applying: _transformations) }))
        }
        
        if let ellipses = self.ellipses {
            try output.append(contentsOf: ellipses.compactMap({ try $0.path(applying: _transformations) }))
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
    
    /// A singular path that represents all of the `Command`s within the document.
    func coalescedPath() throws -> Path {
        let paths = try subpaths()
        let commands = try paths.flatMap({ try $0.commands() })
        return Path(commands: commands)
    }
}
