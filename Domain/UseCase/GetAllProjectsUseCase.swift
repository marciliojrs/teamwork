import RxSwift

/// Retrieve all projects
public protocol GetAllProjectsUseCaseType: UseCase {
    /**
     - returns: Array with all projects.
    */
    func execute() -> Observable<[Project]>
}

public struct GetAllProjectsUseCase: GetAllProjectsUseCaseType {
    public func execute() -> Observable<[Project]> {
        return .just([])
    }
}
