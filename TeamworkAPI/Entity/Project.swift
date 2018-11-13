import Domain

//sourcery: AutoInit
struct Project: AutoCodable, AutoEquatable {
    enum Status: String, Codable {
        case all, active, archived, current, late, completed
    }

    let id: String
    let starred: Bool
    let status: Project.Status
    let logo: String?
    let name: String
    let description: String
    let company: Company
}

extension Domain.Project: DomainEncodable {
    typealias Encoder = Project
    var encoded: Encoder { return Project(with: self) }
}

extension Project: DomainConvertibleType {
    typealias DomainType = Domain.Project

    init(with domain: DomainType) {
        self.name = domain.name
        self.id = domain.id
        self.starred = domain.starred
        self.logo = domain.logo?.absoluteString
        self.description = domain.description
        self.company = domain.company.encoded
        self.status = Project.Status(rawValue: domain.status.rawValue)!
    }

    func asDomain() -> Project.DomainType {
        return Domain.Project(
            id: id,
            starred: starred,
            status: Domain.Project.Status(rawValue: status.rawValue)!,
            logo: logo != nil ? URL(string: logo!) : nil,
            name: name,
            description: description,
            company: company.asDomain()
        )
    }
}
