public protocol Container {
    var circles: [Circle]? { get set }
    var ellipses: [Ellipse]? { get set }
    var groups: [Group]? { get set }
    var lines: [Line]? { get set }
    var paths: [Path]? { get set }
    var polygons: [Polygon]? { get set }
    var polylines: [Polyline]? { get set }
    var rectangles: [Rectangle]? { get set }
    var texts: [Text]? { get set }
}

internal enum ContainerKeys: String, CodingKey {
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

public extension Container {
    var containerDescription: String {
        var contents: String = ""
        
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
        
        return contents
    }
}
