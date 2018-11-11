import Domain

//sourcery: AutoInit
struct Company: AutoEquatable, AutoCodable {
    let id: String
    let name: String
}

extension Domain.Company: DomainEncodable {
    typealias Encoder = Company
    var encoded: Encoder { return Company(with: self) }
}

extension Company: DomainConvertibleType {
    typealias DomainType = Domain.Company

    init(with domain: DomainType) {
        self.id = domain.id
        self.name = domain.name
    }

    func asDomain() -> Company.DomainType {
        return Domain.Company(id: id, name: name)
    }
}
