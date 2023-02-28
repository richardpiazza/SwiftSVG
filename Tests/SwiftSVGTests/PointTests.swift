import XCTest
import Swift2D
@testable import SwiftSVG

final class PointTests: XCTestCase {
    
    let rect = Rect(origin: .zero, size: Size(width: 500, height: 500))
    var center: Point { rect.center }
    
    func testReflection() throws {
        // x=x y=y
        var point = Point(x: 250, y: 250)
        var reflection = point.reflection(using: center)
        XCTAssertEqual(reflection, Point(x: 250, y: 250))
        
        // x→x y↓y
        point = Point(x: 150, y: 50)
        reflection = point.reflection(using: center)
        XCTAssertEqual(reflection, Point(x: 350, y: 450))
        
        // x→x y=y
        point = Point(x: 150, y: 250)
        reflection = point.reflection(using: center)
        XCTAssertEqual(reflection, Point(x: 350, y: 250))
        
        // x=x y↓y
        point = Point(x: 250, y: 50)
        reflection = point.reflection(using: center)
        XCTAssertEqual(reflection, Point(x: 250, y: 450))
        
        // x←x y↑y
        point = Point(x: 350, y: 450)
        reflection = point.reflection(using: center)
        XCTAssertEqual(reflection, Point(x: 150, y: 50))
        
        // x=x y↑y
        point = Point(x: 250, y: 450)
        reflection = point.reflection(using: center)
        XCTAssertEqual(reflection, Point(x: 250, y: 50))
        
        // x←x y=y
        point = Point(x: 350, y: 250)
        reflection = point.reflection(using: center)
        XCTAssertEqual(reflection, Point(x: 150, y: 250))
        
        // x→x y↑y
        point = Point(x: 150, y: 450)
        reflection = point.reflection(using: center)
        XCTAssertEqual(reflection, Point(x: 350, y: 50))
        
        // x←x y↓y
        point = Point(x: 350, y: 50)
        reflection = point.reflection(using: center)
        XCTAssertEqual(reflection, Point(x: 150, y: 450))
    }
}
