import Foundation
import Swift2D

struct CircleProcessor {
    
    let circle: Circle
    
    /// The _optimal_ offset for control points when representing a
    /// circle as 4 bezier curves.
    ///
    /// [Stack Overflow](https://stackoverflow.com/questions/1734745/how-to-create-circle-with-bézier-curves)
    var controlPointOffset: Float {
        return (Float(4.0/3.0) * tan(Float.pi / 8.0)) * circle.r
    }
    
    init(circle: Circle) {
        self.circle = circle
    }
    
    func commands(clockwise: Bool) -> [Path.Command] {
        var commands: [Path.Command] = []
        
        let offset = controlPointOffset
        
        let zero = Point(x: circle.x + circle.r, y: circle.y)
        let ninety = Point(x: circle.x, y: circle.y - circle.r)
        let oneEighty = Point(x: circle.x - circle.r, y: circle.y)
        let twoSeventy = Point(x: circle.x, y: circle.y + circle.r)
        
        var cp1: Point = .zero
        var cp2: Point = .zero
        
        // Starting at degree 0 (the right most point)
        commands.append(.moveTo(point: zero))
        
        if clockwise {
            cp1 = Point(x: zero.x, y: zero.y + offset)
            cp2 = Point(x: twoSeventy.x + offset, y: twoSeventy.y)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: twoSeventy))
            
            cp1 = Point(x: twoSeventy.x - offset, y: twoSeventy.y)
            cp2 = Point(x: oneEighty.x, y: oneEighty.y + offset)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: oneEighty))
            
            cp1 = Point(x: oneEighty.x, y: oneEighty.y - offset)
            cp2 = Point(x: ninety.x - offset, y: ninety.y)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: ninety))
            
            cp1 = Point(x: ninety.x + offset, y: ninety.y)
            cp2 = Point(x: zero.x, y: zero.y - offset)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: zero))
        } else {
            cp1 = Point(x: zero.x, y: zero.y - offset)
            cp2 = Point(x: ninety.x + offset, y: ninety.y)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: ninety))
            
            cp1 = Point(x: ninety.x - offset, y: ninety.y)
            cp2 = Point(x: oneEighty.x, y: oneEighty.y - offset)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: oneEighty))
            
            cp1 = Point(x: oneEighty.x, y: oneEighty.y + offset)
            cp2 = Point(x: twoSeventy.x - offset, y: twoSeventy.y)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: twoSeventy))
            
            cp1 = Point(x: twoSeventy.x + offset, y: twoSeventy.y)
            cp2 = Point(x: zero.x, y: zero.y + offset)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: zero))
        }
        
        commands.append(.closePath)
        
        return commands
    }
    
}
