import Foundation
import Swift2D

public extension Path {
    /// Path commands are instructions that define a path to be drawn.
    ///
    /// Each command is composed of a command letter and numbers that represent the command parameters.
    enum Command: Equatable, CustomStringConvertible {
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
        
        public var description: String {
            switch self {
            case .moveTo(let point):
                return "\(Prefix.move.rawValue)\(point.x),\(point.y)"
            case .lineTo(let point):
                return "\(Prefix.line.rawValue)\(point.x),\(point.y)"
            case .cubicBezierCurve(let cp1, let cp2, let point):
                return "\(Prefix.cubicBezierCurve.rawValue)\(cp1.x),\(cp1.y) \(cp2.x),\(cp2.y) \(point.x),\(point.y)"
            case .quadraticBezierCurve(let cp, let point):
                return "\(Prefix.quadraticBezierCurve.rawValue)\(cp.x),\(cp.y) \(point.x),\(point.y)"
            case .ellipticalArcCurve(let rx, let ry, let largeArc, let clockwise, let point):
                let la = largeArc ? 1 : 0
                let cw = clockwise ? 1 : 0
                return "\(Prefix.ellipticalArcCurve.rawValue)\(rx),\(ry) \(la) \(cw) \(point.x),\(point.y)"
            case .closePath:
                return "\(Prefix.close.rawValue)"
            }
        }
    }
}

public extension Path.Command {
    /// Applies the provided `Transformation` to the instances values.
    func applying(transformation: Transformation) -> Path.Command {
        switch transformation {
        case .translate(let x, let y):
            switch self {
            case .moveTo(let point):
                let _point = point.adjusting(x: x).adjusting(y: y)
                return .moveTo(point: _point)
            case .lineTo(let point):
                let _point = point.adjusting(x: x).adjusting(y: y)
                return .lineTo(point: _point)
            case .cubicBezierCurve(let cp1, let cp2, let point):
                let _cp1 = cp1.adjusting(x: x).adjusting(y: y)
                let _cp2 = cp2.adjusting(x: x).adjusting(y: y)
                let _point = point.adjusting(x: x).adjusting(y: y)
                return .cubicBezierCurve(cp1: _cp1, cp2: _cp2, point: _point)
            case .quadraticBezierCurve(let cp, let point):
                let _cp = cp.adjusting(x: x).adjusting(y: y)
                let _point = point.adjusting(x: x).adjusting(y: y)
                return .quadraticBezierCurve(cp: _cp, point: _point)
            case .ellipticalArcCurve(let rx, let ry, let largeArc, let clockwise, let point):
                let _point = point.adjusting(x: x).adjusting(y: y)
                return .ellipticalArcCurve(rx: rx, ry: ry, largeArc: largeArc, clockwise: clockwise, point: _point)
            case .closePath:
                return self
            }
        case .matrix:
            // TODO: What should occur here?
            return self
        }
    }
}
