public protocol UseCaseFactory: class {
    func makeGetAllProjects() -> GetAllProjectsUseCaseType
}
