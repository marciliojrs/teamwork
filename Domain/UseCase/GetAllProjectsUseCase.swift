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
                let grouped = all.group { $0.status }.sorted(by: { $0.0.order < $1.0.order })
                let array = grouped.compactMap { (_, value) -> [Project] in
                    value.sorted { $0.name.compare($1.name) == .orderedAscending }
                }.flatMap { $0 }

                return array
            }.asSingle()
    }
}

extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}
