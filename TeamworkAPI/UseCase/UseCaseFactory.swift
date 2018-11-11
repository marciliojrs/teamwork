import Foundation
import Domain

public final class UseCaseFactory: Domain.UseCaseFactory {
    private let requestMaker: NetworkRequestMakerType

    public init() { fatalError("init(baseUrl:) must be used") }
    public init(baseUrl: String) {
        self.requestMaker = NetworkRequestMaker(baseUrl: baseUrl)
    }

    public func makeGetAllProjects() -> GetAllProjectsUseCaseType {
        let repository = ProjectRepository(networkMaker: requestMaker)
        return GetAllProjectsUseCase(projectRepository: repository)
    }
}
