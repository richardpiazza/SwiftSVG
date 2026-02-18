import Foundation
import Swift2D
@testable import SwiftSVG

extension Bundle {
    static let swiftSVGTests: Bundle = .module
}

infix operator ~~
public protocol RoughEquatability {
    static func ~~ (lhs: Self, rhs: Self) -> Bool
}

public extension Path.Command {
    func hasPrefix(_ prefix: Path.Command.Prefix) -> Bool {
        switch self {
        case .moveTo:
            return prefix == .move
        case .lineTo:
            return prefix == .line
        case .cubicBezierCurve:
            return prefix == .cubicBezierCurve
        case .quadraticBezierCurve:
            return prefix == .quadraticBezierCurve
        case .ellipticalArcCurve:
            return prefix == .ellipticalArcCurve
        case .closePath:
            return prefix == .close
        }
    }
}

extension Path.Command: RoughEquatability {
    public static func ~~ (lhs: Path.Command, rhs: Path.Command) -> Bool {
        switch (lhs, rhs) {
        case (.moveTo(let lPoint), .moveTo(let rPoint)):
            return lPoint ~~ rPoint
        case (.lineTo(let lPoint), .lineTo(let rPoint)):
            return lPoint ~~ rPoint
        case (.cubicBezierCurve(let lcp1, let lcp2, let lpoint), .cubicBezierCurve(let rcp1, let rcp2, let rpoint)):
            return (lcp1 ~~ rcp1) && (lcp2 ~~ rcp2) && (lpoint ~~ rpoint)
        case (.quadraticBezierCurve(let lcp, let lpoint), .quadraticBezierCurve(let rcp, let rpoint)):
            return (lcp ~~ rcp) && (lpoint ~~ rpoint)
        case (.ellipticalArcCurve(let lrx, let lry, let langle, let llargeArc, let lclockwise, let lpoint), .ellipticalArcCurve(let rrx, let rry, let rangle, let rlargeArc, let rclockwise, let rpoint)):
            return (lrx ~~ rrx) && ((lry ~~ rry)) && (langle ~~ rangle) && (llargeArc == rlargeArc) && (lclockwise == rclockwise) && (lpoint ~~ rpoint)
        case (.closePath, .closePath):
            return true
        default:
            return false
        }
    }
}

extension Double: RoughEquatability {
    public static func ~~ (lhs: Double, rhs: Double) -> Bool {
        // Float.abs is not available on some platforms.
        return Swift.abs(lhs - rhs) < 0.001
    }
}

extension Point: RoughEquatability {
    public static func ~~ (lhs: Point, rhs: Point) -> Bool {
        return (lhs.x ~~ rhs.x) && (lhs.y ~~ rhs.y)
    }
}

extension Array: RoughEquatability where Element == Path.Command {
    public static func ~~ (lhs: Array<Element>, rhs: Array<Element>) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        
        for (idx, i) in lhs.enumerated() {
            if !(i ~~ rhs[idx]) {
                return false
            }
        }
        
        return true
    }
}
