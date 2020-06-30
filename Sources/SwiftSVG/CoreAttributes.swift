public protocol CoreAttributes {
    var id: String? { get set }
}

internal enum CoreAttributesKeys: String, CodingKey {
    case id
}

public extension CoreAttributes {
    var coreDescription: String {
        if let id = self.id {
            return "\(CoreAttributesKeys.id.rawValue)=\"\(id)\""
        } else {
            return ""
        }
    }
}
