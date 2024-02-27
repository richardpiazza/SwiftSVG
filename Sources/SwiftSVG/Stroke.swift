import Swift2D

public struct Stroke {
    public struct Default {
        public static let color = "none"
        public static let width = 1.0
        public static let opacity = 1.0
        public static let lineCap = LineCap.butt
        public static let lineJoin = LineJoin.miter
        public static let miterLimit = 4.0
    }

    public var color: String
    public var width: Double
    public var opacity: Double
    public var lineCap: LineCap
    public var lineJoin: LineJoin
    public var miterLimit: Double
    
    /// Initialize aggregate data related to a `Stroke`.
    ///
    /// Any supplied `nil` values are replaced with the corresponding value from `Stroke.Default`
    ///
    /// - parameters:
    ///   - color: Name of or hexadecimal value used to color the stroke.
    ///   - width: The width of the stroekd line.
    ///   - opacity: The level of opaqueness given applied to the color.
    ///   - rule: Algorithm used to determine the inside of the shape.
    ///   - lineCap: The styling of the endpoints of the stroke.
    ///   - lineJoin: The styling of the joining points of the stroke.
    ///   - miterLimit: Threshold for controlling the length of the miter.
    public init(color: String?, width: Double?, opacity: Double?, lineCap: LineCap?, lineJoin: LineJoin?, miterLimit: Double?) {
        self.color = color ?? Stroke.Default.color
        self.width = width ?? Stroke.Default.width
        self.opacity = opacity ?? Stroke.Default.opacity
        self.lineCap = lineCap ?? Stroke.Default.lineCap
        self.lineJoin = lineJoin ?? Stroke.Default.lineJoin
        self.miterLimit = miterLimit ?? Stroke.Default.miterLimit
    }

    public init() {
        self.init(color: nil,
                  width: nil,
                  opacity: nil,
                  lineCap: nil,
                  lineJoin: nil,
                  miterLimit: nil)
    }
    
    /// Presentation attribute defining the shape to be used at the end of open subpaths when they are stroked.
    ///
    /// The default `LineCap` is `.butt`
    public enum LineCap: String, Codable, CaseIterable {
        /// The stroke for each subpath does not extend beyond its two endpoints.
        case butt
        /// The end of each subpath the stroke will be extended by a half circle with a diameter equal to the stroke
        /// width.
        case round
        /// The end of each subpath the stroke will be extended by a rectangle with a width equal to half the width of
        /// the stroke and a height equal to the width of the stroke.
        case square
    }
    
    /// Presentation attribute defining the shape to be used at the corners of paths when they are stroked.
    ///
    /// The default `LineJoin` is `.miter`
    public enum LineJoin: String, Codable, CaseIterable {
        /// An arcs corner is to be used to join path segments.
        ///
        /// The arcs shape is formed by extending the outer edges of the stroke at the join point with arcs that have
        /// the same curvature as the outer edges at the join point.
        case arcs
        /// The bevel value indicates that a bevelled corner is to be used to join path segments.
        case bevel
        /// Indicates that a sharp corner is to be used to join path segments.
        ///
        /// The corner is formed by extending the outer edges of the stroke at the tangents of the path segments until
        /// they intersect.
        case miter
        /// A sharp corner is to be used to join path segments.
        ///
        /// The corner is formed by extending the outer edges of the stroke at the tangents of the path segments until
        /// they intersect.
        case miterClip = "miter-clip"
        /// The round value indicates that a round corner is to be used to join path segments.
        case round
    }
}

extension Stroke.LineCap: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

extension Stroke.LineJoin: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}
