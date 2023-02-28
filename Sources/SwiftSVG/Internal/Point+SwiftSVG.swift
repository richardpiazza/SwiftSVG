import Swift2D

extension Point {
    static var nan: Point {
        return Point(x: Double.nan, y: Double.nan)
    }
    
    var hasNaN: Bool {
        return x.isNaN || y.isNaN
    }
    
    /// Returns a copy of the instance with the **x** value replaced with the provided value.
    func with(x value: Double) -> Point {
        return Point(x: value, y: y)
    }
    
    /// Returns a copy of the instance with the **y** value replaced with the provided value.
    func with(y value: Double) -> Point {
        return Point(x: x, y: value)
    }
    
    /// Adjusts the **x** value by the provided amount.
    ///
    /// This will explicitly check for `.isNaN`, and if encountered, will simply
    /// use the provided value.
    func adjusting(x value: Double) -> Point {
        return (x.isNaN) ? with(x: value) : with(x: x + value)
    }
    
    /// Adjusts the **y** value by the provided amount.
    ///
    /// This will explicitly check for `.isNaN`, and if encountered, will simply
    /// use the provided value.
    func adjusting(y value: Double) -> Point {
        return (y.isNaN) ? with(y: value) : with(y: y + value)
    }
    
    /// Determine the reflection
    func reflection(using point: Point) -> Point {
        if x < point.x {
            let reflectionX = point.x + (point.x - x)
            
            if y < point.y {
                let reflectionY = point.y + (point.y - y)
                return Point(x: reflectionX, y: reflectionY)
            } else if y > point.y {
                let reflectionY = point.y - (y - point.y)
                return Point(x: reflectionX, y: reflectionY)
            }
            
            return Point(x: reflectionX, y: y)
        } else if x > point.x {
            let reflectionX = point.x - (x - point.x)
            
            if y < point.y {
                let reflectionY = point.y + (point.y - y)
                return Point(x: reflectionX, y: reflectionY)
            } else if y > point.y {
                let reflectionY = point.y - (y - point.y)
                return Point(x: reflectionX, y: reflectionY)
            }
            
            return Point(x: reflectionX, y: y)
        }
        
        if y < point.y {
            let reflectionY = point.y + (point.y - y)
            return Point(x: x, y: reflectionY)
        } else if y > point.y {
            let reflectionY = point.y - (y - point.y)
            return Point(x: x, y: reflectionY)
        }
        
        return Point(x: x, y: y)
    }
}
