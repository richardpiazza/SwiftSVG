import Foundation
import Swift2D

struct PathProcessor {
    
    let data: String
    
    init(data: String) {
        self.data = data
    }
    
    func commands() throws -> [Path.Command] {
        var commands: [Path.Command] = []
        var builder = Builder()
        let components = components(from: data).filter { !$0.isEmpty }
        
        try components.forEach { component in
            if let prefix = Path.Command.Prefix(rawValue: component.first!) {
                if let command = builder.setup(prefix: prefix, lastCommand: commands.last) {
                    commands.append(command)
                }
            } else if let value = Double(component) {
                if let command = try builder.process(value: value, lastCommand: commands.last) {
                    commands.append(command)
                }
            } else {
                throw Path.Command.Error.message("Unhandled Command Component: \(component)")
            }
        }
        
        if let command = builder.command, command.isComplete {
            commands.append(command)
        }
        
        return commands
    }
    
    /// Interprets the `data` attribute into individual components for `Command` processing.
    private func components(from data: String) -> [String] {
        var components: [String] = []
        
        var component: String = ""
        
        data.unicodeScalars.forEach { (scalar) in
            if scalar == "e" {
                // Account for exponential value notation.
                component.append(String(scalar))
                return
            }
            
            if CharacterSet.letters.contains(scalar) {
                if !component.isEmpty {
                    components.append(component)
                    component = ""
                }
                
                components.append(String(scalar))
                return
            }
            
            if CharacterSet.whitespaces.contains(scalar) {
                if !component.isEmpty {
                    components.append(component)
                    component = ""
                }
                
                return
            }
            
            if CharacterSet(charactersIn: ",").contains(scalar) {
                if !component.isEmpty {
                    components.append(component)
                    component = ""
                }
                
                return
            }
            
            if CharacterSet(charactersIn: "-").contains(scalar) {
                if !component.isEmpty && component.last != "e" {
                    // Again, account for exponential values.
                    components.append(component)
                    component = ""
                }
                
                component.append(String(scalar))
                return
            }
            
            if CharacterSet(charactersIn: ".").contains(scalar) {
                if component.contains(".") {
                    // Already decimal value, this is a new value
                    components.append(component)
                    component = ""
                }
                
                component.append(String(scalar))
                return
            }
            
            if CharacterSet.decimalDigits.contains(scalar) {
                component.append(String(scalar))
                return
            }
            
            print("Unhandled Character: \(scalar)")
        }
        
        if !component.isEmpty {
            components.append(component)
            component = ""
        }
        
        return components
    }
    
    struct Builder {
        /// The command currently being built
        var command: Path.Command?
        /// Coordinate system being used
        var coordinates: Path.Command.Coordinates = .absolute
        /// The argument position of the _command_ to be processed.
        var position: Int = 0
        /// Indicates that only a single value will be processed on the next component pass.
        var singleValue: Bool = false
        /// The originating coordinates of the path.
        var pathOrigin: Point = .nan
        /// The last point as processed by the builder.
        var currentPoint: Point = .zero
        
        mutating func setup(prefix: Path.Command.Prefix, lastCommand: Path.Command?) -> Path.Command? {
            position = 0
            singleValue = false
            
            switch prefix {
            case .move:
                command = .moveTo(point: .nan)
                coordinates = .absolute
            case .relativeMove:
                command = .moveTo(point: currentPoint)
                coordinates = .relative
            case .line:
                command = .lineTo(point: .nan)
                coordinates = .absolute
            case .relativeLine:
                command = .lineTo(point: currentPoint)
                coordinates = .relative
            case .horizontalLine:
                command = .lineTo(point: currentPoint.with(x: .nan))
                coordinates = .absolute
            case .relativeHorizontalLine:
                command = .lineTo(point: currentPoint)
                coordinates = .relative
                singleValue = true
            case .verticalLine:
                command = .lineTo(point: currentPoint.with(y: .nan))
                coordinates = .absolute
                position = 1
            case .relativeVerticalLine:
                command = .lineTo(point: currentPoint)
                coordinates = .relative
                position = 1
                singleValue = true
            case .cubicBezierCurve:
                command = .cubicBezierCurve(cp1: .nan, cp2: .nan, point: .nan)
                coordinates = .absolute
            case .relativeCubicBezierCurve:
                command = .cubicBezierCurve(cp1: currentPoint, cp2: currentPoint, point: currentPoint)
                coordinates = .relative
            case .smoothCubicBezierCurve:
                command = .cubicBezierCurve(cp1: currentPoint, cp2: .nan, point: .nan)
                coordinates = .absolute
                position = 2
            case .relativeSmoothCubicBezierCurve:
                command = .cubicBezierCurve(cp1: currentPoint, cp2: currentPoint, point: currentPoint)
                coordinates = .relative
                position = 2
            case .quadraticBezierCurve:
                command = .quadraticBezierCurve(cp: .nan, point: .nan)
                coordinates = .absolute
            case .relativeQuadraticBezierCurve:
                command = .quadraticBezierCurve(cp: currentPoint, point: currentPoint)
                coordinates = .relative
            case .smoothQuadraticBezierCurve:
                if case .quadraticBezierCurve(let cp, _) = lastCommand {
                    command = .quadraticBezierCurve(cp: cp.reflection(using: currentPoint), point: .nan)
                } else {
                    command = .quadraticBezierCurve(cp: currentPoint, point: .nan)
                }
                coordinates = .absolute
                position = 2
            case .relativeSmoothQuadraticBezierCurve:
                if case .quadraticBezierCurve(let cp, _) = lastCommand {
                    command = .quadraticBezierCurve(cp: cp.reflection(using: currentPoint), point: .nan)
                } else {
                    command = .quadraticBezierCurve(cp: currentPoint, point: .nan)
                }
                coordinates = .relative
                position = 2
            case .ellipticalArcCurve:
                command = .ellipticalArcCurve(rx: .nan, ry: .nan, angle: .nan, largeArc: false, clockwise: false, point: .nan)
                coordinates = .absolute
            case .relativeEllipticalArcCurve:
                command = .ellipticalArcCurve(rx: .nan, ry: .nan, angle: .nan, largeArc: false, clockwise: false, point: currentPoint)
                coordinates = .relative
            case .close, .relativeClose:
                currentPoint = pathOrigin
                reset()
                return .closePath
            }
            
            return nil
        }
        
        mutating func process(value: Double, lastCommand: Path.Command?) throws -> Path.Command? {
            if let command = command {
                try continueCommand(command, with: value)
            } else {
                try nextCommand(with: value, lastCommand: lastCommand)
            }
            
            if let command = command, command.isComplete {
                switch coordinates {
                case .relative:
                    guard position == -1 else {
                        return nil
                    }
                    
                    fallthrough
                case .absolute:
                    currentPoint = command.point
                    if case .moveTo = command {
                        pathOrigin = command.point
                    }
                    reset()
                    return command
                }
            } else {
                return nil
            }
        }
        
        private mutating func continueCommand(_ command: Path.Command, with value: Double) throws {
            switch command {
            case .moveTo, .cubicBezierCurve, .quadraticBezierCurve, .ellipticalArcCurve:
                self.command = try command.adjustingArgument(at: position, by: value)
                switch coordinates {
                case .absolute:
                     position += 1
                case .relative:
                    switch position {
                    case 0...(command.arguments - 2):
                        position += 1
                    case command.arguments - 1:
                        position = -1
                    default:
                        break //throw?
                    }
                }
            case .lineTo:
                self.command = try command.adjustingArgument(at: position, by: value)
                switch coordinates {
                case .absolute:
                    position += 1
                case .relative:
                    switch position {
                    case 0:
                        if singleValue {
                            singleValue = false
                            position = -1
                        } else {
                            position += 1
                        }
                    case 1:
                        if singleValue {
                            singleValue = false
                        }
                        position = -1
                    default:
                        break //throw?
                    }
                }
            case .closePath:
                break
            }
        }
        
        private mutating func nextCommand(with value: Double, lastCommand: Path.Command?) throws {
            guard let command = lastCommand else {
                throw Path.Command.Error.invalidRelativeCommand
            }
            
            switch command {
            case .moveTo:
                switch coordinates {
                case .absolute:
                    self.command = .lineTo(point: Point(x: value, y: .nan))
                    position = 1
                case .relative:
                    let c = Path.Command.lineTo(point: command.point)
                    self.command = try c.adjustingArgument(at: 0, by: value)
                    position = 1
                }
            case .lineTo:
                switch coordinates {
                case .absolute:
                    self.command = .lineTo(point: Point(x: value, y: .nan))
                    position = 1
                case .relative:
                    let c = Path.Command.lineTo(point: command.point)
                    self.command = try c.adjustingArgument(at: 0, by: value)
                    position = 1
                }
            case .cubicBezierCurve:
                switch coordinates {
                case .absolute:
                    self.command = .cubicBezierCurve(cp1: Point(x: value, y: .nan), cp2: .nan, point: .nan)
                    position = 1
                case .relative:
                    let c = Path.Command.cubicBezierCurve(cp1: command.point, cp2: command.point, point: command.point)
                    self.command = try c.adjustingArgument(at: 0, by: value)
                    position = 1
                }
            case .quadraticBezierCurve:
                switch coordinates {
                case .absolute:
                    self.command = .quadraticBezierCurve(cp: Point(x: value, y: .nan), point: .nan)
                    position = 1
                case .relative:
                    let c = Path.Command.quadraticBezierCurve(cp: command.point, point: command.point)
                    self.command = try c.adjustingArgument(at: 0, by: value)
                    position = 1
                }
            case .ellipticalArcCurve:
                switch coordinates {
                case .absolute:
                    self.command = .ellipticalArcCurve(rx: value, ry: .nan, angle: .nan, largeArc: false, clockwise: false, point: .nan)
                    position = 1
                case .relative:
                    let c = Path.Command.ellipticalArcCurve(rx: .nan, ry: .nan, angle: .nan, largeArc: false, clockwise: false, point: command.point)
                    self.command = try c.adjustingArgument(at: 0, by: value)
                    position = 1
                }
            case .closePath:
                break
            }
        }
        
        private mutating func reset() {
            command = nil
            coordinates = .absolute
            position = 0
            singleValue = false
        }
    }
}
