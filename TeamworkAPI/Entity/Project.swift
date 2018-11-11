import Domain

//sourcery: AutoInit
struct Project: AutoCodable, AutoEquatable {
    enum Status: String, Codable {
        case all, active, archived, current, late, completed
    }

    let id: String
    let starred: Bool
    let status: Project.Status
    let logo: URL
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
        self.logo = domain.logo
        self.description = domain.description
        self.company = domain.company.encoded
        self.status = Project.Status(rawValue: domain.status.rawValue)!
    }

    func asDomain() -> Project.DomainType {
        return Domain.Project(
            id: id,
            starred: starred,
            status: Domain.Project.Status(rawValue: status.rawValue)!,
            logo: logo,
            name: name,
            description: description,
            company: company.asDomain()
        )
    }
}
