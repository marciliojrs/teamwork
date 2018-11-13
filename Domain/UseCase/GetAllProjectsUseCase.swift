import RxSwift

/// Retrieve all projects
public protocol GetAllProjectsUseCaseType: UseCase {
    /**
     - returns: Array with all projects.
    */
    func execute() -> Single<[Project]>

    /**
     - parameters:
     projectRepository: A project repository instance.
     */
    init(projectRepository: ProjectRepositoryType)
}

public struct GetAllProjectsUseCase: GetAllProjectsUseCaseType {
    private let repository: ProjectRepositoryType
    public init(projectRepository: ProjectRepositoryType) {
        repository = projectRepository
    }

    public func execute() -> Single<[Project]> {
        return repository.all()
            .map { (all) -> [Project] in
                let grouped = all.categorise { $0.status }
                let array = grouped.compactMap { (_, value) -> [Project] in
                    value.sorted { $0.name.compare($1.name) == .orderedAscending }
                }.reversed().flatMap { $0 }

                return array
            }.asSingle()
    }
}

extension Sequence {
    func categorise<U: Hashable>(_ key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        var dict: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = dict[key]?.append(element) { dict[key] = [element] }
        }

        return dict
    }
}
