import Foundation
import Swift2D

extension Point {
    var hasNaN: Bool {
        return x.isNaN || y.isNaN
    }
    
    func with(x value: Float) -> Point {
        return Point(x: value, y: y)
    }
    
    func with(y value: Float) -> Point {
        return Point(x: x, y: value)
    }
    
    func adjusting(x value: Float) -> Point {
        return (x.isNaN) ? with(x: value) : with(x: x + value)
    }
    
    func adjusting(y value: Float) -> Point {
        return (y.isNaN) ? with(y: value) : with(y: y + value)
    }
}
