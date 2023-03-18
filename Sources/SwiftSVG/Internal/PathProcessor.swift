import Foundation

struct PathProcessor {
    
    let data: String
    
    init(data: String) {
        self.data = data
    }
    
    func commands() throws -> [Path.Command] {
        let parser = Path.ComponentParser()
        let components = try Path.Component.components(from: data)
        return try parser.parse(components)
    }
}
