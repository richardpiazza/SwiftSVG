import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

class PathProcessor {
    
    enum Positioning {
        case absolute
        case relative
    }
    
    let data: String
    
    private var _command: Path.Command?
    private var positioning: Positioning = .absolute
    private var pathOrigin: CGPoint = .nan
    private var currentPoint: CGPoint = .zero
    /// The argument position of the _command to be processed.
    private var argumentPosition: Int = 0
    /// Indicates that only a single `Float` will be processed on the next component pass.
    private var singleValue: Bool = false
    private var _commands: [Path.Command] = []
    
    init(data: String) {
        self.data = data
    }
    
    /// Processes the `commandComponents`.
    ///
    /// For each of the command components:
    /// * If a `Path.Command.Prefix` is identified: Setup a new `Command`.
    /// * If a `Float` is identified: Continue a non-complete `Command`, or begin a new command using the last prefix.
    /// * Ascertain if the command is complete and update `pathOrigin`/`currentPoint`.
    func commands() throws -> [Path.Command] {
        _commands.removeAll()
        let components = data.commandComponents.filter({ !$0.isEmpty })
        for component in components {
            if let prefix = Path.Command.Prefix(rawValue: component.first!) {
                switch prefix {
                case .close, .relativeClose:
                    _commands.append(.closePath)
                    // Reset & Process Next Component
                    _command = nil
                    currentPoint = pathOrigin
                default:
                    try setupCommand(prefix: prefix)
                }
            } else if let _value = Float(component) {
                let value = CGFloat(_value)
                if let command = _command {
                    try continueCommand(command, value: value)
                } else {
                    try setupNextCommand(value: value)
                }
                
                if let command = _command, command.isComplete {
                    switch positioning {
                    case .relative:
                        guard argumentPosition == -1 else {
                            break
                        }
                        
                        fallthrough
                    case .absolute:
                        _commands.append(command)
                        _command = nil
                        if case .moveTo = command {
                            pathOrigin = command.point
                        }
                        currentPoint = command.point
                    }
                }
            } else {
                print("Unhandled Component: \(component)")
            }
        }
        
        if let command = _command, command.isComplete {
            _commands.append(command)
            if case .moveTo = command {
                pathOrigin = command.point
            }
        }
        
        if case .closePath = _commands.last {
            // Do Nothing
        } else {
            _commands.append(.closePath)
        }
        
        return _commands
    }
    
    /// Setup Command
    private func setupCommand(prefix: Path.Command.Prefix) throws {
        switch prefix {
        case .move:
            _command = .moveTo(point: .nan)
            positioning = .absolute
            argumentPosition = 0
        case .relativeMove:
            _command = .moveTo(point: currentPoint)
            positioning = .relative
            argumentPosition = 0
        case .line:
            _command = .lineTo(point: .nan)
            positioning = .absolute
            argumentPosition = 0
        case .relativeLine:
            _command = .lineTo(point: currentPoint)
            positioning = .relative
            argumentPosition = 0
        case .horizontalLine:
            _command = .lineTo(point: currentPoint.with(x: .nan))
            positioning = .absolute
            argumentPosition = 0
        case .relativeHorizontalLine:
            _command = .lineTo(point: currentPoint)
            positioning = .relative
            argumentPosition = 0
            singleValue = true
        case .verticalLine:
            _command = .lineTo(point: currentPoint.with(y: .nan))
            positioning = .absolute
            argumentPosition = 0
        case .relativeVerticalLine:
            _command = .lineTo(point: currentPoint)
            positioning = .relative
            argumentPosition = 1
            singleValue = true
        case .cubicBezierCurve:
            _command = .cubicBezierCurve(cp1: .nan, cp2: .nan, point: .nan)
            positioning = .absolute
            argumentPosition = 0
        case .relativeCubicBezierCurve:
            _command = .cubicBezierCurve(cp1: currentPoint, cp2: currentPoint, point: currentPoint)
            positioning = .relative
            argumentPosition = 0
        case .smoothCubicBezierCurve:
            _command = .cubicBezierCurve(cp1: currentPoint, cp2: .nan, point: .nan)
            positioning = .absolute
            argumentPosition = 0
        case .relativeSmoothCubicBezierCurve:
            _command = .cubicBezierCurve(cp1: currentPoint, cp2: currentPoint, point: currentPoint)
            positioning = .relative
            argumentPosition = 2
        case .quadraticBezierCurve:
            _command = .quadraticBezierCurve(cp: .nan, point: .nan)
            positioning = .absolute
            argumentPosition = 0
        case .relativeQuadraticBezierCurve:
            _command = .quadraticBezierCurve(cp: currentPoint, point: currentPoint)
            positioning = .relative
            argumentPosition = 0
        case .smoothQuadraticBezierCurve:
            guard let command = _commands.last else {
                throw Path.Command.Error.invalidRelativeCommand
            }
            guard let lastControlPoint = command.lastControlPoint else {
                throw Path.Command.Error.invalidRelativeCommand
            }
            _command = .quadraticBezierCurve(cp: lastControlPoint, point: .nan)
            positioning = .absolute
            argumentPosition = 0
        case .relativeSmoothQuadraticBezierCurve:
            guard let command = _commands.last else {
                throw Path.Command.Error.invalidRelativeCommand
            }
            guard let lastControlPoint = command.lastControlPoint else {
                throw Path.Command.Error.invalidRelativeCommand
            }
            _command = .quadraticBezierCurve(cp: lastControlPoint, point: currentPoint)
            positioning = .relative
            argumentPosition = 2
        case .ellipticalArcCurve:
            _command = .ellipticalArcCurve(rx: .nan, ry: .nan, angle: .nan, largeArc: false, clockwise: false, point: .nan)
            positioning = .absolute
            argumentPosition = 0
        case .relativeEllipticalArcCurve:
            _command = .ellipticalArcCurve(rx: .nan, ry: .nan, angle: .nan, largeArc: false, clockwise: false, point: currentPoint)
            positioning = .relative
            argumentPosition = 0
        case .close, .relativeClose:
            break
        }
    }
    
    /// Process Value
    private func continueCommand(_ command: Path.Command, value: CGFloat) throws {
        switch command {
        case .moveTo, .cubicBezierCurve, .quadraticBezierCurve, .ellipticalArcCurve:
            _command = try command.adjustingArgument(at: argumentPosition, by: value)
            switch positioning {
            case .absolute:
                 argumentPosition += 1
            case .relative:
                switch argumentPosition {
                case 0...(command.arguments - 2):
                    argumentPosition += 1
                case command.arguments - 1:
                    argumentPosition = -1
                default:
                    break //throw?
                }
            }
        case .lineTo:
            _command = try command.adjustingArgument(at: argumentPosition, by: value)
            switch positioning {
            case .absolute:
                argumentPosition += 1
            case .relative:
                switch argumentPosition {
                case 0:
                    if singleValue {
                        singleValue = false
                        argumentPosition = -1
                    } else {
                        argumentPosition += 1
                    }
                case 1:
                    if singleValue {
                        singleValue = false
                    }
                    argumentPosition = -1
                default:
                    break //throw?
                }
            }
        case .closePath:
            break
        }
    }
    
    /// New Command (using the last prefix)
    private func setupNextCommand(value: CGFloat) throws {
        guard let command = _commands.last else {
            throw Path.Command.Error.invalidRelativeCommand
        }
        
        switch command {
        case .moveTo:
            switch positioning {
            case .absolute:
                _command = .moveTo(point: CGPoint(x: value, y: .nan))
                argumentPosition = 1
            case .relative:
                let c = Path.Command.moveTo(point: command.point)
                _command = try c.adjustingArgument(at: 0, by: value)
                argumentPosition = 1
            }
        case .lineTo:
            switch positioning {
            case .absolute:
                _command = .lineTo(point: CGPoint(x: value, y: .nan))
                argumentPosition = 1
            case .relative:
                let c = Path.Command.lineTo(point: command.point)
                _command = try c.adjustingArgument(at: 0, by: value)
                argumentPosition = 1
            }
        case .cubicBezierCurve:
            switch positioning {
            case .absolute:
                _command = .cubicBezierCurve(cp1: CGPoint(x: value, y: .nan), cp2: .nan, point: .nan)
                argumentPosition = 1
            case .relative:
                let c = Path.Command.cubicBezierCurve(cp1: command.point, cp2: command.point, point: command.point)
                _command = try c.adjustingArgument(at: 0, by: value)
                argumentPosition = 1
            }
        case .quadraticBezierCurve:
            switch positioning {
            case .absolute:
                _command = .quadraticBezierCurve(cp: CGPoint(x: value, y: .nan), point: .nan)
                argumentPosition = 1
            case .relative:
                let c = Path.Command.quadraticBezierCurve(cp: command.point, point: command.point)
                _command = try c.adjustingArgument(at: 0, by: value)
                argumentPosition = 1
            }
        case .ellipticalArcCurve:
            switch positioning {
            case .absolute:
                _command = .ellipticalArcCurve(rx: value, ry: .nan, angle: .nan, largeArc: false, clockwise: false, point: .nan)
                argumentPosition = 1
            case .relative:
                let c = Path.Command.ellipticalArcCurve(rx: .nan, ry: .nan, angle: .nan, largeArc: false, clockwise: false, point: command.point)
                _command = try c.adjustingArgument(at: 0, by: value)
                argumentPosition = 1
            }
        case .closePath:
            break
        }
    }
}

private extension String {
    /// Interprets the `data` attribute into individual components for `Command` processing.
    var commandComponents: [String] {
        var components: [String] = []
        
        var component: String = ""
        
        self.unicodeScalars.forEach { (scalar) in
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
        
        return components.filter({ !$0.isEmpty })
    }
}
