import XCTest
@testable import SwiftSVG

final class CommandRepresentableTests: XCTestCase {
    
    static var allTests = [
        ("testCircle", testCircle),
        ("testLine", testLine),
        ("testPolygon", testPolygon),
        ("testPolyline", testPolyline),
        ("testRectangle", testRectangle),
        ("testRoundedRectangle", testRoundedRectangle),
        ("testCubicRoundedRectangle", testCubicRoundedRectangle)
    ]
    
    func testCircle() throws {
        let circle = Circle(x: 50, y: 50, r: 50)
        let offset = EllipseProcessor.controlPointOffset(circle.r)
        
        var commands = try circle.commands(clockwise: false)
        
        var expected: [Path.Command] = [
            .moveTo(point: .init(x: 100.0, y: 50.0)),
            .cubicBezierCurve(cp1: .init(x: 100.0, y: 50.0 - offset), cp2: .init(x: 50.0 + offset, y: 0.0), point: .init(x: 50.0, y: 0.0)),
            .cubicBezierCurve(cp1: .init(x: 50.0 - offset, y: 0.0), cp2: .init(x: 0.0, y: 50.0 - offset), point: .init(x: 0.0, y: 50.0)),
            .cubicBezierCurve(cp1: .init(x: 0.0, y: 50.0 + offset), cp2: .init(x: 50.0 - offset, y: 100.0), point: .init(x: 50.0, y: 100.0)),
            .cubicBezierCurve(cp1: .init(x: 50.0 + offset, y: 100.0), cp2: .init(x: 100.0, y: 50.0 + offset), point: .init(x: 100.0, y: 50.0)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
        
        commands = try circle.commands(clockwise: true)
        
        expected = [
            .moveTo(point: .init(x: 100.0, y: 50.0)),
            .cubicBezierCurve(cp1: .init(x: 100.0, y: 50.0 + offset), cp2: .init(x: 50.0 + offset, y: 100.0), point: .init(x: 50.0, y: 100.0)),
            .cubicBezierCurve(cp1: .init(x: 50.0 - offset, y: 100.0), cp2: .init(x: 0.0, y: 50.0 + offset), point: .init(x: 0.0, y: 50.0)),
            .cubicBezierCurve(cp1: .init(x: 0.0, y: 50.0 - offset), cp2: .init(x: 50.0 - offset, y: 0.0), point: .init(x: 50.0, y: 0.0)),
            .cubicBezierCurve(cp1: .init(x: 50.0 + offset, y: 0.0), cp2: .init(x: 100.0, y: 50.0 - offset), point: .init(x: 100.0, y: 50.0)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
    }
    
    func testEllipse() throws {
        let x: CGFloat = 50.0
        let y: CGFloat = 25.0
        
        let ellipse = Ellipse(x: x, y: y, rx: 50, ry: 25)
        let xOffset = EllipseProcessor.controlPointOffset(ellipse.rx)
        let yOffset = EllipseProcessor.controlPointOffset(ellipse.ry)
        
        var commands = try ellipse.commands(clockwise: false)
        
        var expected: [Path.Command] = [
            .moveTo(point: .init(x: x * 2, y: y)),
            .cubicBezierCurve(cp1: .init(x: x * 2, y: y - yOffset), cp2: .init(x: x + xOffset, y: 0.0), point: .init(x: x, y: 0.0)),
            .cubicBezierCurve(cp1: .init(x: x - xOffset, y: 0.0), cp2: .init(x: 0.0, y: y - yOffset), point: .init(x: 0.0, y: y )),
            .cubicBezierCurve(cp1: .init(x: 0.0, y: y + yOffset), cp2: .init(x: x - xOffset, y: y * 2), point: .init(x: x, y: y * 2)),
            .cubicBezierCurve(cp1: .init(x: x + xOffset, y: y * 2), cp2: .init(x: x * 2, y: y + yOffset), point: .init(x: x * 2, y: y)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
        
        commands = try ellipse.commands(clockwise: true)
        
        expected = [
            .moveTo(point: .init(x: x * 2, y: y)),
            .cubicBezierCurve(cp1: .init(x: x * 2, y: y + yOffset), cp2: .init(x: x + xOffset, y: y * 2), point: .init(x: x, y: y * 2)),
            .cubicBezierCurve(cp1: .init(x: x - xOffset, y: y * 2), cp2: .init(x: 0.0, y: y + yOffset), point: .init(x: 0.0, y: y)),
            .cubicBezierCurve(cp1: .init(x: 0.0, y: y - yOffset), cp2: .init(x: x - xOffset, y: 0.0), point: .init(x: x, y: 0.0)),
            .cubicBezierCurve(cp1: .init(x: x + xOffset, y: 0.0), cp2: .init(x: x * 2, y: y - yOffset), point: .init(x: x * 2, y: y)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
    }
    
    func testLine() throws {
        let line = Line(x1: 10.0, y1: 10.0, x2: 80.0, y2: 30.0)
        let commands = try line.commands()
        
        let expected: [Path.Command] = [
            .moveTo(point: .init(x: 10.0, y: 10.0)),
            .lineTo(point: .init(x: 80.0, y: 30.0)),
            .lineTo(point: .init(x: 10.0, y: 10.0)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
    }
    
    func testPolygon() throws {
        let polygon = SwiftSVG.Polygon(points: "850,75 958,137.5 958,262.5 850,325 742,262.6 742,137.5")
        let commands = try polygon.commands()
        
        let expected: [Path.Command] = [
            .moveTo(point: .init(x: 850.0, y: 75.0)),
            .lineTo(point: .init(x: 958.0, y: 137.5)),
            .lineTo(point: .init(x: 958.0, y: 262.5)),
            .lineTo(point: .init(x: 850.0, y: 325.0)),
            .lineTo(point: .init(x: 742.0, y: 262.6)),
            .lineTo(point: .init(x: 742.0, y: 137.5)),
            .closePath
        ]
        
        XCTAssertRoughlyEqual(commands, expected)
    }
    
    func testPolyline() throws {
        let polyline = Polyline(points: "")
        let commands = try polyline.commands()
        
        let expected: [Path.Command] = [
        ]
        
        XCTAssertEqual(commands, expected)
    }
    
    func testRectangle() throws {
        let rectangle = Rectangle(x: 0, y: 0, width: 100, height: 100)
        var commands = try rectangle.commands(clockwise: true)
        
        var expected: [Path.Command] = [
            .moveTo(point: .init(x: 0.0, y: 0.0)),
            .lineTo(point: .init(x: 100.0, y: 0.0)),
            .lineTo(point: .init(x: 100.0, y: 100.0)),
            .lineTo(point: .init(x: 0.0, y: 100.0)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
        
        commands = try rectangle.commands(clockwise: false)
        
        expected = [
            .moveTo(point: .init(x: 0.0, y: 0.0)),
            .lineTo(point: .init(x: 0.0, y: 100.0)),
            .lineTo(point: .init(x: 100.0, y: 100.0)),
            .lineTo(point: .init(x: 100.0, y: 0.0)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
    }
    
    func testRoundedRectangle() throws {
        let rectangle = Rectangle(x: 0, y: 0, width: 100, height: 100, rx: 15)
        var commands = try rectangle.commands(clockwise: true)
        
        var expected: [Path.Command] = [
            .moveTo(point: .init(x: 15.0, y: 0.0)),
            .lineTo(point: .init(x: 85.0, y: 0.0)),
            .quadraticBezierCurve(cp: .init(x: 100.0, y: 0.0), point: .init(x: 100.0, y: 15.0)),
            .lineTo(point: .init(x: 100.0, y: 85.0)),
            .quadraticBezierCurve(cp: .init(x: 100.0, y: 100.0), point: .init(x: 85.0, y: 100.0)),
            .lineTo(point: .init(x: 15.0, y: 100.0)),
            .quadraticBezierCurve(cp: .init(x: 0.0, y: 100.0), point: .init(x: 0.0, y: 85.0)),
            .lineTo(point: .init(x: 0.0, y: 15.0)),
            .quadraticBezierCurve(cp: .zero, point: .init(x: 15.0, y: 0.0)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
        
        commands = try rectangle.commands(clockwise: false)
        
        expected = [
            .moveTo(point: .init(x: 15.0, y: 0.0)),
            .quadraticBezierCurve(cp: .zero, point: .init(x: 0.0, y: 15.0)),
            .lineTo(point: .init(x: 0.0, y: 85.0)),
            .quadraticBezierCurve(cp: .init(x: 0.0, y: 100.0), point: .init(x: 15.0, y: 100.0)),
            .lineTo(point: .init(x: 85.0, y: 100.0)),
            .quadraticBezierCurve(cp: .init(x: 100.0, y: 100.0), point: .init(x: 100.0, y: 85.0)),
            .lineTo(point: .init(x: 100.0, y: 15.0)),
            .quadraticBezierCurve(cp: .init(x: 100.0, y: 0.0), point: .init(x: 85.0, y: 0.0)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
    }
    
    func testCubicRoundedRectangle() throws {
        let rectangle = Rectangle(x: 0, y: 0, width: 100, height: 100, rx: 10, ry: 20)
        var commands = try rectangle.commands(clockwise: true)
        
        var expected: [Path.Command] = [
            .moveTo(point: .init(x: 10.0, y: 0.0)),
            .lineTo(point: .init(x: 90.0, y: 0.0)),
            .cubicBezierCurve(cp1: .init(x: 100.0, y: 0.0), cp2: .init(x: 100.0, y: 0.0), point: .init(x: 100.0, y: 20.0)),
            .lineTo(point: .init(x: 100.0, y: 80.0)),
            .cubicBezierCurve(cp1: .init(x: 100.0, y: 100.0), cp2: .init(x: 100.0, y: 100.0), point: .init(x: 90.0, y: 100.0)),
            .lineTo(point: .init(x: 10.0, y: 100.0)),
            .cubicBezierCurve(cp1: .init(x: 0.0, y: 100.0), cp2: .init(x: 0.0, y: 100.0), point: .init(x: 0.0, y: 80.0)),
            .lineTo(point: .init(x: 0.0, y: 20.0)),
            .cubicBezierCurve(cp1: .zero, cp2: .zero, point: .init(x: 10.0, y: 0.0)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
        
        commands = try rectangle.commands(clockwise: false)
        
        expected = [
            .moveTo(point: .init(x: 10.0, y: 0.0)),
            .cubicBezierCurve(cp1: .zero, cp2: .zero, point: .init(x: 0.0, y: 20.0)),
            .lineTo(point: .init(x: 0.0, y: 80.0)),
            .cubicBezierCurve(cp1: .init(x: 0.0, y: 100.0), cp2: .init(x: 0.0, y: 100.0), point: .init(x: 10.0, y: 100.0)),
            .lineTo(point: .init(x: 90.0, y: 100.0)),
            .cubicBezierCurve(cp1: .init(x: 100.0, y: 100.0), cp2: .init(x: 100.0, y: 100.0), point: .init(x: 100.0, y: 80.0)),
            .lineTo(point: .init(x: 100.0, y: 20.0)),
            .cubicBezierCurve(cp1: .init(x: 100.0, y: 0.0), cp2: .init(x: 100.0, y: 0.0), point: .init(x: 90.0, y: 0.0)),
            .closePath
        ]
        
        XCTAssertEqual(commands, expected)
    }
}
