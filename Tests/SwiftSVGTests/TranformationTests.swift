import XCTest
@testable import SwiftSVG

final class TransformationTests: XCTestCase {
    
    static var allTests = [
        ("testTranslateInitialization", testTranslateInitialization),
        ("testMatrixInitialization", testMatrixInitialization),
        ("testCommandTransformation", testCommandTransformation)
    ]
    
    func testTranslateInitialization() {
        var input: String = "translate(0.000000, 39.000000)"
        var transformation: Transformation? = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .translate(x, y) = transformation {
            XCTAssertEqual(x, 0.0, accuracy: 0.00001)
            XCTAssertEqual(y, 39.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
        
        input = "translate(0.0 39.0)"
        transformation = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .translate(x, y) = transformation {
            XCTAssertEqual(x, 0.0, accuracy: 0.00001)
            XCTAssertEqual(y, 39.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
        
        input = "TRANSLATE(0.0,39.0)"
        transformation = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .translate(x, y) = transformation {
            XCTAssertEqual(x, 0.0, accuracy: 0.00001)
            XCTAssertEqual(y, 39.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
    }
    
    func testMatrixInitialization() {
        var input: String = "matrix(1 0 0 1 1449.84 322)"
        var transformation: Transformation? = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .matrix(a, b, c, d, e, f) = transformation {
            XCTAssertEqual(a, 1.0, accuracy: 0.00001)
            XCTAssertEqual(b, 0.0, accuracy: 0.00001)
            XCTAssertEqual(c, 0.0, accuracy: 0.00001)
            XCTAssertEqual(d, 1.0, accuracy: 0.00001)
            XCTAssertEqual(e, 1449.84, accuracy: 0.001)
            XCTAssertEqual(f, 322.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
        
        input = "matrix(1, 0, 0, 1, 1449.84, 322)"
        transformation = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .matrix(a, b, c, d, e, f) = transformation {
            XCTAssertEqual(a, 1.0, accuracy: 0.00001)
            XCTAssertEqual(b, 0.0, accuracy: 0.00001)
            XCTAssertEqual(c, 0.0, accuracy: 0.00001)
            XCTAssertEqual(d, 1.0, accuracy: 0.00001)
            XCTAssertEqual(e, 1449.84, accuracy: 0.001)
            XCTAssertEqual(f, 322.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
        
        input = "MATRIX(1,0,0,1,1449.84,322)"
        transformation = Transformation(input)
        
        XCTAssertNotNil(transformation)
        if case let .matrix(a, b, c, d, e, f) = transformation {
            XCTAssertEqual(a, 1.0, accuracy: 0.00001)
            XCTAssertEqual(b, 0.0, accuracy: 0.00001)
            XCTAssertEqual(c, 0.0, accuracy: 0.00001)
            XCTAssertEqual(d, 1.0, accuracy: 0.00001)
            XCTAssertEqual(e, 1449.84, accuracy: 0.001)
            XCTAssertEqual(f, 322.0, accuracy: 0.00001)
        } else {
            XCTFail()
            return
        }
    }
    
    func testCommandTransformation() throws {
        let translate = Transformation.translate(x: 25.0, y: 75.0)
        var command: Path.Command
        var result: Path.Command
        
        command = .moveTo(point: .init(x: 50.0, y: 50.0))
        result = command.applying(transformation: translate)
        
        if case let .moveTo(point) = result {
            XCTAssertEqual(point, .init(x: 75.0, y: 125.0))
        } else {
            XCTFail()
            return
        }
        
        command = .lineTo(point: .init(x: -60.0, y: 120.0))
        result = command.applying(transformation: translate)
        
        if case let .lineTo(point) = result {
            XCTAssertEqual(point, .init(x: -35.0, y: 195.0))
        } else {
            XCTFail()
            return
        }
        
        command = .cubicBezierCurve(cp1: .init(x: -20.0, y: -40.0), cp2: .init(x: 18.0, y: 94.0), point: .init(x: 20.0, y: 20.0))
        result = command.applying(transformation: translate)
        
        if case let .cubicBezierCurve(cp1, cp2, point) = result {
            XCTAssertEqual(cp1, .init(x: 5.0, y: 35.0))
            XCTAssertEqual(cp2, .init(x: 43.0, y: 169.0))
            XCTAssertEqual(point, .init(x: 45.0, y: 95.0))
        } else {
            XCTFail()
            return
        }
        
        command = .quadraticBezierCurve(cp: .init(x: 100.0, y: 50.0), point: .zero)
        result = command.applying(transformation: translate)
        
        if case let .quadraticBezierCurve(cp, point) = result {
            XCTAssertEqual(cp, .init(x: 125.0, y: 125.0))
            XCTAssertEqual(point, .init(x: 25.0, y: 75.0))
        } else {
            XCTFail()
            return
        }
        
        command = .closePath
        result = command.applying(transformation: translate)
        
        if case .closePath = result {
        } else {
            XCTFail()
            return
        }
    }
}
