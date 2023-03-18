import Foundation
import Swift2D

struct PathProcessor {
    
    let data: String
    
    init(data: String) {
        self.data = data
    }
    
    func commands() throws -> [Path.Command] {
        let components = Path.Component.components(from: data)
        let parser = Path.Component.Parser()
        return try parser.parse(components)
    }
}
