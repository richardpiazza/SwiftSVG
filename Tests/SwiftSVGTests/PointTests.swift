import Swift2D
@testable import SwiftSVG
import Testing

struct PointTests {

    let rect = Rect(origin: .zero, size: Size(width: 500, height: 500))
    var center: Point { rect.center }

    @Test func pointReflecting() {
        // x=x y=y
        var point = Point(x: 250, y: 250)
        var reflection = point.reflecting(around: center)
        #expect(reflection == Point(x: 250, y: 250))

        // x→x y↓y
        point = Point(x: 150, y: 50)
        reflection = point.reflecting(around: center)
        #expect(reflection == Point(x: 350, y: 450))

        // x→x y=y
        point = Point(x: 150, y: 250)
        reflection = point.reflecting(around: center)
        #expect(reflection == Point(x: 350, y: 250))

        // x=x y↓y
        point = Point(x: 250, y: 50)
        reflection = point.reflecting(around: center)
        #expect(reflection == Point(x: 250, y: 450))

        // x←x y↑y
        point = Point(x: 350, y: 450)
        reflection = point.reflecting(around: center)
        #expect(reflection == Point(x: 150, y: 50))

        // x=x y↑y
        point = Point(x: 250, y: 450)
        reflection = point.reflecting(around: center)
        #expect(reflection == Point(x: 250, y: 50))

        // x←x y=y
        point = Point(x: 350, y: 250)
        reflection = point.reflecting(around: center)
        #expect(reflection == Point(x: 150, y: 250))

        // x→x y↑y
        point = Point(x: 150, y: 450)
        reflection = point.reflecting(around: center)
        #expect(reflection == Point(x: 350, y: 50))

        // x←x y↓y
        point = Point(x: 350, y: 50)
        reflection = point.reflecting(around: center)
        #expect(reflection == Point(x: 150, y: 450))
    }
}
