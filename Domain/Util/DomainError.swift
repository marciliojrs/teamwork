import Foundation

public enum DomainError: Swift.Error {
    case unknown
    case objectMapping(type: Any)
    case invalidModel(key: String, type: Any)
    case underlying(Swift.Error)
    case invalidModelTransform
    case itemNotFound(id: String, type: Any)
}
