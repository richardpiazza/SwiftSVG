import Foundation

struct EllipseProcessor {
    
    let x: CGFloat
    let y: CGFloat
    let rx: CGFloat
    let ry: CGFloat
    
    /// The _optimal_ offset for control points when representing a
    /// circle/ellipse as 4 bezier curves.
    ///
    /// [Stack Overflow](https://stackoverflow.com/questions/1734745/how-to-create-circle-with-bézier-curves)
    static func controlPointOffset(_ radius: CGFloat) -> CGFloat {
        return (CGFloat(4.0/3.0) * tan(CGFloat.pi / 8.0)) * radius
    }
    
    init(ellipse: Ellipse) {
        x = ellipse.x
        y = ellipse.y
        rx = ellipse.rx
        ry = ellipse.ry
    }
    
    init(circle: Circle) {
        x = circle.x
        y = circle.y
        rx = circle.r
        ry = circle.y
    }
    
    func commands(clockwise: Bool) -> [Path.Command] {
        var commands: [Path.Command] = []
        
        let xOffset = Self.controlPointOffset(rx)
        let yOffset = Self.controlPointOffset(ry)
        
        let zero = CGPoint(x: x + rx, y: y)
        let ninety = CGPoint(x: x, y: y - ry)
        let oneEighty = CGPoint(x: x - rx, y: y)
        let twoSeventy = CGPoint(x: x, y: y + ry)
        
        var cp1: CGPoint = .zero
        var cp2: CGPoint = .zero
        
        // Starting at degree 0 (the right most point)
        commands.append(.moveTo(point: zero))
        
        if clockwise {
            cp1 = CGPoint(x: zero.x, y: zero.y + yOffset)
            cp2 = CGPoint(x: twoSeventy.x + xOffset, y: twoSeventy.y)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: twoSeventy))
            
            cp1 = CGPoint(x: twoSeventy.x - xOffset, y: twoSeventy.y)
            cp2 = CGPoint(x: oneEighty.x, y: oneEighty.y + yOffset)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: oneEighty))
            
            cp1 = CGPoint(x: oneEighty.x, y: oneEighty.y - yOffset)
            cp2 = CGPoint(x: ninety.x - xOffset, y: ninety.y)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: ninety))
            
            cp1 = CGPoint(x: ninety.x + xOffset, y: ninety.y)
            cp2 = CGPoint(x: zero.x, y: zero.y - yOffset)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: zero))
        } else {
            cp1 = CGPoint(x: zero.x, y: zero.y - yOffset)
            cp2 = CGPoint(x: ninety.x + xOffset, y: ninety.y)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: ninety))
            
            cp1 = CGPoint(x: ninety.x - xOffset, y: ninety.y)
            cp2 = CGPoint(x: oneEighty.x, y: oneEighty.y - yOffset)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: oneEighty))
            
            cp1 = CGPoint(x: oneEighty.x, y: oneEighty.y + yOffset)
            cp2 = CGPoint(x: twoSeventy.x - xOffset, y: twoSeventy.y)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: twoSeventy))
            
            cp1 = CGPoint(x: twoSeventy.x + xOffset, y: twoSeventy.y)
            cp2 = CGPoint(x: zero.x, y: zero.y + yOffset)
            commands.append(.cubicBezierCurve(cp1: cp1, cp2: cp2, point: zero))
        }
        
        commands.append(.closePath)
        
        return commands
    }
    
}
