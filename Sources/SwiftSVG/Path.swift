import Foundation
import XMLCoder
import Swift2D

/// Generic element to define a shape.
///
/// A path is defined by including a ‘path’ element in a SVG document which contains a **d="(path data)"**
/// attribute, where the **‘d’** attribute contains the moveto, line, curve (both Cubic and Quadratic Bézier),
/// arc and closepath instructions.
///
/// ## Documentation
/// [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/path)
/// | [W3](https://www.w3.org/TR/SVG11/paths.html)
public class Path: Element {
    
    /// Path commands are instructions that define a path to be drawn.
    ///
    /// Each command is composed of a command letter and numbers that represent the command parameters.
    public enum Command {
        /// Moves the current drawing point
        case moveTo(point: Point)
        /// Draw a straight line from the current point to the point provided
        case lineTo(point: Point)
        /// Draw a smooth curve using three points (+ origin)
        case cubicBezierCurve(cp1: Point, cp2: Point, point: Point)
        /// Draw a smooth curve using two points (+ origin)
        case quadraticBezierCurve(cp: Point, point: Point)
        /// Draw a curve defined as a portion of an ellipse
        case ellipticalArcCurve(rx: Float, ry: Float, largeArc: Bool, clockwise: Bool, point: Point)
        /// ClosePath instructions draw a straight line from the current position to the first point in the path.
        case closePath
        
        public enum Prefix: Character, CaseIterable {
            case move = "M"
            case relativeMove = "m"
            case line = "L"
            case relativeLine = "l"
            case horizontalLine = "H"
            case relativeHorizontalLine = "h"
            case verticalLine = "V"
            case relativeVerticalLine = "v"
            case cubicBezierCurve = "C"
            case relativeCubicBezierCurve = "c"
            case smoothCubicBezierCurve = "S"
            case relativeSmoothCubicBezierCurve = "s"
            case quadraticBezierCurve = "Q"
            case relativeQuadraticBezierCurve = "q"
            case smoothQuadraticBezierCurve = "T"
            case relativeSmoothQuadraticBezierCurve = "t"
            case ellipticalArcCurve = "A"
            case relativeEllipticalArcCurve = "a"
            case close = "Z"
            case relativeClose = "z"
            
            public static var characterSet: CharacterSet {
                return CharacterSet(charactersIn: allCases.map({ String($0.rawValue) }).joined())
            }
        }
        
        public enum Error: Swift.Error {
            case message(String)
            case invalidAdjustment(Path.Command)
            case invalidArgumentPosition(Int, Path.Command)
            case invalidRelativeCommand
        }
    }
    
    /// The definition of the outline of a shape.
    public var data: String = ""
    
    enum CodingKeys: String, CodingKey {
        case data = "d"
    }

    public override init() {
        super.init()
    }
    
    public convenience init(data: String) {
        self.init()
        self.data = data
    }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(String.self, forKey: .data) ?? ""
    }
    
    // MARK: - CustomStringConvertible
    public override var description: String {
        return "<path d=\"\(data)\" \(super.description) />"
    }
}

// MARK: - DynamicNodeEncoding
extension Path: DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        return .attribute
    }
}

// MARK: - DynamicNodeDecoding
extension Path: DynamicNodeDecoding {
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        return .attribute
    }
}

// MARK: - CommandRepresentable
extension Path: CommandRepresentable {
    public func commands() throws -> [Command] {
        return try PathProcessor(data: data).commands()
    }
}
