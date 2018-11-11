import RxSwift

/// Get a specific product by id
public protocol GetProjectByIdUseCaseType: UseCase {
    /**
     - returns: Single event with retrieved project.
     */
    func execute(id: String) -> Single<Project>

    /**
     - parameters:
     projectRepository: A project repository instance.
     */
    init(projectRepository: ProjectRepositoryType)
}

public struct GetProjectByIdUseCase: GetProjectByIdUseCaseType {
    private let repository: ProjectRepositoryType
    public init(projectRepository: ProjectRepositoryType) {
        repository = projectRepository
    }

    public func execute(id: String) -> Single<Project> {
        guard !id.isEmpty else { return .error(DomainError.validation(["id": "id cannot be empty"])) }
        return repository.project(by: id).asSingle()
    }
}
