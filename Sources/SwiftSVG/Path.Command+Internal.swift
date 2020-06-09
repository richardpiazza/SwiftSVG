import Foundation
import Swift2D

extension Path.Command {
    /// Determines if all values are provided (i.e. !.isNaN)
    var isComplete: Bool {
        switch self {
        case .moveTo(let point), .lineTo(let point):
            return !point.hasNaN
        case .cubicBezierCurve(let cp1, let cp2, let point):
            return !cp1.hasNaN && !cp2.hasNaN && !point.hasNaN
        case .quadraticBezierCurve(let cp, let point):
            return !cp.hasNaN && !point.hasNaN
        case .ellipticalArcCurve(let rx, let ry, _, _, let point):
            return !rx.isNaN && !ry.isNaN && !point.hasNaN
        case .closePath:
            return true
        }
    }
    
    var point: Point {
        switch self {
        case .moveTo(let point): return point
        case .lineTo(let point): return point
        case .cubicBezierCurve(_, _, let point): return point
        case .quadraticBezierCurve(_, let point): return point
        case .ellipticalArcCurve(_, _, _, _, let point): return point
        case .closePath: return .zero
        }
    }
    
    /// The last control point used in drawing the path.
    ///
    /// Only valid for curves.
    var lastControlPoint: Point? {
        switch self {
        case .cubicBezierCurve(_, let cp2, _):
            return cp2
        case .quadraticBezierCurve(let cp, _):
            return cp
        default:
            return nil
        }
    }
    
    /// A mirror representation of `lastControlPoint`.
    var lastControlPointMirror: Point? {
        guard let cp = lastControlPoint else {
            return nil
        }
        
        return Point(x: point.x + (point.x - cp.x), y: point.y + (point.y - cp.y))
    }
    
    /// Adjusts a Command argument by a specified amount.
    ///
    /// A `Point` consumes two positions. So, in the example `.quadraticBezierCurve(cp: .zero, point: .zero)`:
    /// * position 0 = Control Point X
    /// * position 1 = Control Point Y
    /// * position 2 = Point X
    /// * position 3 = Point Y
    ///
    /// - parameter position: The index of the argument parameter to adjust.
    /// - parameter value: The value to add to the existing value. If the current value equal `.isNaN`, than the
    ///                    supplied value is used as-is.
    /// - throws: `Path.Command.Error`
    func adjustingArgument(at position: Int, by value: Float) throws -> Path.Command {
        switch self {
        case .moveTo(let point):
            switch position {
            case 0:
                return .moveTo(point: point.adjusting(x: value))
            case 1:
                return .moveTo(point: point.adjusting(y: value))
            default:
                throw Path.Command.Error.invalidArgumentPosition(position, self)
            }
        case .lineTo(let point):
            switch position {
            case 0:
                return .lineTo(point: point.adjusting(x: value))
            case 1:
                return .lineTo(point: point.adjusting(y: value))
            default:
                throw Path.Command.Error.invalidArgumentPosition(position, self)
            }
        case .cubicBezierCurve(let cp1, let cp2, let point):
            switch position {
            case 0:
                return .cubicBezierCurve(cp1: cp1.adjusting(x: value), cp2: cp2, point: point)
            case 1:
                return .cubicBezierCurve(cp1: cp1.adjusting(y: value), cp2: cp2, point: point)
            case 2:
                return .cubicBezierCurve(cp1: cp1, cp2: cp2.adjusting(x: value), point: point)
            case 3:
                return .cubicBezierCurve(cp1: cp1, cp2: cp2.adjusting(y: value), point: point)
            case 4:
                return .cubicBezierCurve(cp1: cp1, cp2: cp2, point: point.adjusting(x: value))
            case 5:
                return .cubicBezierCurve(cp1: cp1, cp2: cp2, point: point.adjusting(y: value))
            default:
                throw Path.Command.Error.invalidArgumentPosition(position, self)
            }
        case .quadraticBezierCurve(let cp, let point):
            switch position {
            case 0:
                return .quadraticBezierCurve(cp: cp.adjusting(x: value), point: point)
            case 1:
                return .quadraticBezierCurve(cp: cp.adjusting(y: value), point: point)
            case 2:
                return .quadraticBezierCurve(cp: cp, point: point.adjusting(x: value))
            case 3:
                return .quadraticBezierCurve(cp: cp, point: point.adjusting(y: value))
            default:
                throw Path.Command.Error.invalidArgumentPosition(position, self)
            }
        case .ellipticalArcCurve(let rx, let ry, let largeArc, let clockwise, let point):
            switch position {
            case 0:
                return .ellipticalArcCurve(rx: (rx.isNaN) ? value : rx + value, ry: ry, largeArc: largeArc, clockwise: clockwise, point: point)
            case 1:
                return .ellipticalArcCurve(rx: rx, ry: (ry.isNaN) ? value : ry + value, largeArc: largeArc, clockwise: clockwise, point: point)
            case 2:
                return .ellipticalArcCurve(rx: rx, ry: ry, largeArc: !value.isZero, clockwise: clockwise, point: point)
            case 3:
                return .ellipticalArcCurve(rx: rx, ry: ry, largeArc: largeArc, clockwise: !value.isZero, point: point)
            case 4:
                return .ellipticalArcCurve(rx: rx, ry: ry, largeArc: largeArc, clockwise: clockwise, point: point.adjusting(x: value))
            case 5:
                return .ellipticalArcCurve(rx: rx, ry: ry, largeArc: largeArc, clockwise: clockwise, point: point.adjusting(y: value))
            default:
                throw Path.Command.Error.invalidArgumentPosition(position, self)
            }
        case .closePath:
            throw Path.Command.Error.invalidAdjustment(self)
        }
    }
}
