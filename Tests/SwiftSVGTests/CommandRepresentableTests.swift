import Swift2D
@testable import SwiftSVG
import Testing

struct CommandRepresentableTests {

    @Test func circle() throws {
        let circle = Circle(x: 50, y: 50, r: 50)
        let offset = EllipseProcessor.controlPointOffset(circle.r)

        var commands = try circle.commands(clockwise: false)

        var expected: [Path.Command] = [
            .moveTo(point: Point(x: 100.0, y: 50.0)),
            .cubicBezierCurve(cp1: Point(x: 100.0, y: 50.0 - offset), cp2: Point(x: 50.0 + offset, y: 0.0), point: Point(x: 50.0, y: 0.0)),
            .cubicBezierCurve(cp1: Point(x: 50.0 - offset, y: 0.0), cp2: Point(x: 0.0, y: 50.0 - offset), point: Point(x: 0.0, y: 50.0)),
            .cubicBezierCurve(cp1: Point(x: 0.0, y: 50.0 + offset), cp2: Point(x: 50.0 - offset, y: 100.0), point: Point(x: 50.0, y: 100.0)),
            .cubicBezierCurve(cp1: Point(x: 50.0 + offset, y: 100.0), cp2: Point(x: 100.0, y: 50.0 + offset), point: Point(x: 100.0, y: 50.0)),
            .closePath,
        ]

        #expect(commands == expected)

        commands = try circle.commands(clockwise: true)

        expected = [
            .moveTo(point: Point(x: 100.0, y: 50.0)),
            .cubicBezierCurve(cp1: Point(x: 100.0, y: 50.0 + offset), cp2: Point(x: 50.0 + offset, y: 100.0), point: Point(x: 50.0, y: 100.0)),
            .cubicBezierCurve(cp1: Point(x: 50.0 - offset, y: 100.0), cp2: Point(x: 0.0, y: 50.0 + offset), point: Point(x: 0.0, y: 50.0)),
            .cubicBezierCurve(cp1: Point(x: 0.0, y: 50.0 - offset), cp2: Point(x: 50.0 - offset, y: 0.0), point: Point(x: 50.0, y: 0.0)),
            .cubicBezierCurve(cp1: Point(x: 50.0 + offset, y: 0.0), cp2: Point(x: 100.0, y: 50.0 - offset), point: Point(x: 100.0, y: 50.0)),
            .closePath,
        ]

        #expect(commands == expected)
    }

    @Test func ellipse() throws {
        let x: Double = 50.0
        let y: Double = 25.0

        let ellipse = Ellipse(x: x, y: y, rx: 50, ry: 25)
        let xOffset = EllipseProcessor.controlPointOffset(ellipse.rx)
        let yOffset = EllipseProcessor.controlPointOffset(ellipse.ry)

        var commands = try ellipse.commands(clockwise: false)

        var expected: [Path.Command] = [
            .moveTo(point: Point(x: x * 2, y: y)),
            .cubicBezierCurve(cp1: Point(x: x * 2, y: y - yOffset), cp2: Point(x: x + xOffset, y: 0.0), point: Point(x: x, y: 0.0)),
            .cubicBezierCurve(cp1: Point(x: x - xOffset, y: 0.0), cp2: Point(x: 0.0, y: y - yOffset), point: Point(x: 0.0, y: y)),
            .cubicBezierCurve(cp1: Point(x: 0.0, y: y + yOffset), cp2: Point(x: x - xOffset, y: y * 2), point: Point(x: x, y: y * 2)),
            .cubicBezierCurve(cp1: Point(x: x + xOffset, y: y * 2), cp2: Point(x: x * 2, y: y + yOffset), point: Point(x: x * 2, y: y)),
            .closePath,
        ]

        #expect(commands == expected)

        commands = try ellipse.commands(clockwise: true)

        expected = [
            .moveTo(point: Point(x: x * 2, y: y)),
            .cubicBezierCurve(cp1: Point(x: x * 2, y: y + yOffset), cp2: Point(x: x + xOffset, y: y * 2), point: Point(x: x, y: y * 2)),
            .cubicBezierCurve(cp1: Point(x: x - xOffset, y: y * 2), cp2: Point(x: 0.0, y: y + yOffset), point: Point(x: 0.0, y: y)),
            .cubicBezierCurve(cp1: Point(x: 0.0, y: y - yOffset), cp2: Point(x: x - xOffset, y: 0.0), point: Point(x: x, y: 0.0)),
            .cubicBezierCurve(cp1: Point(x: x + xOffset, y: 0.0), cp2: Point(x: x * 2, y: y - yOffset), point: Point(x: x * 2, y: y)),
            .closePath,
        ]

        #expect(commands == expected)
    }

    @Test func line() throws {
        let line = Line(x1: 10.0, y1: 10.0, x2: 80.0, y2: 30.0)
        let commands = try line.commands()

        let expected: [Path.Command] = [
            .moveTo(point: Point(x: 10.0, y: 10.0)),
            .lineTo(point: Point(x: 80.0, y: 30.0)),
            .lineTo(point: Point(x: 10.0, y: 10.0)),
            .closePath,
        ]

        #expect(commands == expected)
    }

    @Test func polygon() throws {
        let polygon = SwiftSVG.Polygon(points: "850,75 958,137.5 958,262.5 850,325 742,262.6 742,137.5")
        let commands = try polygon.commands()

        let expected: [Path.Command] = [
            .moveTo(point: Point(x: 850.0, y: 75.0)),
            .lineTo(point: Point(x: 958.0, y: 137.5)),
            .lineTo(point: Point(x: 958.0, y: 262.5)),
            .lineTo(point: Point(x: 850.0, y: 325.0)),
            .lineTo(point: Point(x: 742.0, y: 262.6)),
            .lineTo(point: Point(x: 742.0, y: 137.5)),
            .closePath,
        ]

        #expect(commands == expected)
    }

    @Test func polyline() throws {
        let polyline = Polyline(points: "")
        let commands = try polyline.commands()

        let expected: [Path.Command] = [
        ]

        #expect(commands == expected)
    }

    @Test func rectangle() throws {
        let rectangle = Rectangle(x: 0, y: 0, width: 100, height: 100)
        var commands = try rectangle.commands(clockwise: true)

        var expected: [Path.Command] = [
            .moveTo(point: Point(x: 0.0, y: 0.0)),
            .lineTo(point: Point(x: 100.0, y: 0.0)),
            .lineTo(point: Point(x: 100.0, y: 100.0)),
            .lineTo(point: Point(x: 0.0, y: 100.0)),
            .closePath,
        ]

        #expect(commands == expected)

        commands = try rectangle.commands(clockwise: false)

        expected = [
            .moveTo(point: Point(x: 0.0, y: 0.0)),
            .lineTo(point: Point(x: 0.0, y: 100.0)),
            .lineTo(point: Point(x: 100.0, y: 100.0)),
            .lineTo(point: Point(x: 100.0, y: 0.0)),
            .closePath,
        ]

        #expect(commands == expected)
    }

    @Test func roundedRectangle() throws {
        let rectangle = Rectangle(x: 0, y: 0, width: 100, height: 100, rx: 15)
        var commands = try rectangle.commands(clockwise: true)

        var expected: [Path.Command] = [
            .moveTo(point: Point(x: 15.0, y: 0.0)),
            .lineTo(point: Point(x: 85.0, y: 0.0)),
            .quadraticBezierCurve(cp: Point(x: 100.0, y: 0.0), point: Point(x: 100.0, y: 15.0)),
            .lineTo(point: Point(x: 100.0, y: 85.0)),
            .quadraticBezierCurve(cp: Point(x: 100.0, y: 100.0), point: Point(x: 85.0, y: 100.0)),
            .lineTo(point: Point(x: 15.0, y: 100.0)),
            .quadraticBezierCurve(cp: Point(x: 0.0, y: 100.0), point: Point(x: 0.0, y: 85.0)),
            .lineTo(point: Point(x: 0.0, y: 15.0)),
            .quadraticBezierCurve(cp: .zero, point: Point(x: 15.0, y: 0.0)),
            .closePath,
        ]

        #expect(commands == expected)

        commands = try rectangle.commands(clockwise: false)

        expected = [
            .moveTo(point: Point(x: 15.0, y: 0.0)),
            .quadraticBezierCurve(cp: .zero, point: Point(x: 0.0, y: 15.0)),
            .lineTo(point: Point(x: 0.0, y: 85.0)),
            .quadraticBezierCurve(cp: Point(x: 0.0, y: 100.0), point: Point(x: 15.0, y: 100.0)),
            .lineTo(point: Point(x: 85.0, y: 100.0)),
            .quadraticBezierCurve(cp: Point(x: 100.0, y: 100.0), point: Point(x: 100.0, y: 85.0)),
            .lineTo(point: Point(x: 100.0, y: 15.0)),
            .quadraticBezierCurve(cp: Point(x: 100.0, y: 0.0), point: Point(x: 85.0, y: 0.0)),
            .closePath,
        ]

        #expect(commands == expected)
    }

    @Test func cubicRoundedRectangle() throws {
        let rectangle = Rectangle(x: 0, y: 0, width: 100, height: 100, rx: 10, ry: 20)
        var commands = try rectangle.commands(clockwise: true)

        var expected: [Path.Command] = [
            .moveTo(point: Point(x: 10.0, y: 0.0)),
            .lineTo(point: Point(x: 90.0, y: 0.0)),
            .cubicBezierCurve(cp1: Point(x: 100.0, y: 0.0), cp2: Point(x: 100.0, y: 0.0), point: Point(x: 100.0, y: 20.0)),
            .lineTo(point: Point(x: 100.0, y: 80.0)),
            .cubicBezierCurve(cp1: Point(x: 100.0, y: 100.0), cp2: Point(x: 100.0, y: 100.0), point: Point(x: 90.0, y: 100.0)),
            .lineTo(point: Point(x: 10.0, y: 100.0)),
            .cubicBezierCurve(cp1: Point(x: 0.0, y: 100.0), cp2: Point(x: 0.0, y: 100.0), point: Point(x: 0.0, y: 80.0)),
            .lineTo(point: Point(x: 0.0, y: 20.0)),
            .cubicBezierCurve(cp1: .zero, cp2: .zero, point: Point(x: 10.0, y: 0.0)),
            .closePath,
        ]

        #expect(commands == expected)

        commands = try rectangle.commands(clockwise: false)

        expected = [
            .moveTo(point: Point(x: 10.0, y: 0.0)),
            .cubicBezierCurve(cp1: .zero, cp2: .zero, point: Point(x: 0.0, y: 20.0)),
            .lineTo(point: Point(x: 0.0, y: 80.0)),
            .cubicBezierCurve(cp1: Point(x: 0.0, y: 100.0), cp2: Point(x: 0.0, y: 100.0), point: Point(x: 10.0, y: 100.0)),
            .lineTo(point: Point(x: 90.0, y: 100.0)),
            .cubicBezierCurve(cp1: Point(x: 100.0, y: 100.0), cp2: Point(x: 100.0, y: 100.0), point: Point(x: 100.0, y: 80.0)),
            .lineTo(point: Point(x: 100.0, y: 20.0)),
            .cubicBezierCurve(cp1: Point(x: 100.0, y: 0.0), cp2: Point(x: 100.0, y: 0.0), point: Point(x: 90.0, y: 0.0)),
            .closePath,
        ]

        #expect(commands == expected)
    }
}
