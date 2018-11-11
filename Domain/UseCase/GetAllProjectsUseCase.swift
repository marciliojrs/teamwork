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
        return repository.all().asSingle()
    }
}
