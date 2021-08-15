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
}
