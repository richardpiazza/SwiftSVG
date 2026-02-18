import Swift2D
@testable import SwiftSVG
import Testing

struct TransformationTests {

    @Test func translateInitialization() throws {
        var input: String = "translate(0.000000, 39.000000)"
        var transformation: Transformation = try #require(Transformation(input))

        if case let .translate(x, y) = transformation {
            #expect(x == 0.0) // , accuracy: 0.00001
            #expect(y == 39.0) // , accuracy: 0.00001
        } else {
            Issue.record("Unexpected Case")
        }
        
        input = "translate(0.0 39.0)"
        transformation = try #require(Transformation(input))

        if case let .translate(x, y) = transformation {
            #expect(x == 0.0) // , accuracy: 0.00001
            #expect(y == 39.0) // , accuracy: 0.00001
        } else {
            Issue.record("Unexpected Case")
        }
        
        input = "TRANSLATE(0.0,39.0)"
        transformation = try #require(Transformation(input))

        if case let .translate(x, y) = transformation {
            #expect(x == 0.0) // , accuracy: 0.00001
            #expect(y == 39.0) // , accuracy: 0.00001
        } else {
            Issue.record("Unexpected Case")
        }
    }
    
    @Test func matrixInitialization() throws {
        var input: String = "matrix(1 0 0 1 1449.84 322)"
        var transformation: Transformation = try #require(Transformation(input))

        if case let .matrix(a, b, c, d, e, f) = transformation {
            #expect(a == 1.0) // , accuracy: 0.00001
            #expect(b == 0.0) // , accuracy: 0.00001
            #expect(c == 0.0) // , accuracy: 0.00001
            #expect(d == 1.0) // , accuracy: 0.00001
            #expect(e == 1449.84) // , accuracy: 0.001
            #expect(f == 322.0) // , accuracy: 0.00001
        } else {
            Issue.record("Unexpected Case")
        }
        
        input = "matrix(1, 0, 0, 1, 1449.84, 322)"
        transformation = try #require(Transformation(input))

        if case let .matrix(a, b, c, d, e, f) = transformation {
            #expect(a == 1.0) // , accuracy: 0.00001
            #expect(b == 0.0) // , accuracy: 0.00001
            #expect(c == 0.0) // , accuracy: 0.00001
            #expect(d == 1.0) // , accuracy: 0.00001
            #expect(e == 1449.84) // 4, accuracy: 0.001
            #expect(f == 322.0) // , accuracy: 0.00001
        } else {
            Issue.record("Unexpected Case")
        }
        
        input = "MATRIX(1,0,0,1,1449.84,322)"
        transformation = try #require(Transformation(input))

        if case let .matrix(a, b, c, d, e, f) = transformation {
            #expect(a == 1.0) // , accuracy: 0.00001
            #expect(b == 0.0) // , accuracy: 0.00001
            #expect(c == 0.0) // , accuracy: 0.00001
            #expect(d == 1.0) // , accuracy: 0.00001
            #expect(e == 1449.84) // , accuracy: 0.001
            #expect(f == 322.0) // , accuracy: 0.00001
        } else {
            Issue.record("Unexpected Case")
        }
    }
    
    @Test func commandTransformation() throws {
        let translate = Transformation.translate(x: 25.0, y: 75.0)
        var command: Path.Command
        var result: Path.Command
        
        command = .moveTo(point: Point(x: 50.0, y: 50.0))
        result = command.applying(transformation: translate)
        
        if case let .moveTo(point) = result {
            #expect(point == Point(x: 75.0, y: 125.0))
        } else {
            Issue.record("Unexpected Case")
        }
        
        command = .lineTo(point: Point(x: -60.0, y: 120.0))
        result = command.applying(transformation: translate)
        
        if case let .lineTo(point) = result {
            #expect(point == Point(x: -35.0, y: 195.0))
        } else {
            Issue.record("Unexpected Case")
        }
        
        command = .cubicBezierCurve(cp1: Point(x: -20.0, y: -40.0), cp2: Point(x: 18.0, y: 94.0), point: Point(x: 20.0, y: 20.0))
        result = command.applying(transformation: translate)
        
        if case let .cubicBezierCurve(cp1, cp2, point) = result {
            #expect(cp1 == Point(x: 5.0, y: 35.0))
            #expect(cp2 == Point(x: 43.0, y: 169.0))
            #expect(point == Point(x: 45.0, y: 95.0))
        } else {
            Issue.record("Unexpected Case")
        }
        
        command = .quadraticBezierCurve(cp: Point(x: 100.0, y: 50.0), point: .zero)
        result = command.applying(transformation: translate)
        
        if case let .quadraticBezierCurve(cp, point) = result {
            #expect(cp == Point(x: 125.0, y: 125.0))
            #expect(point == Point(x: 25.0, y: 75.0))
        } else {
            Issue.record("Unexpected Case")
        }
        
        command = .closePath
        result = command.applying(transformation: translate)
        
        if case .closePath = result {
        } else {
            Issue.record("Unexpected Case")
        }
    }
}
