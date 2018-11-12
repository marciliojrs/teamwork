import RxCocoa
import RxSwift
import Domain

struct ProjectDetailViewModel: RxViewModel {
    let input: ProjectDetailViewModel.Input
    let output: ProjectDetailViewModel.Output

    private let bag = DisposeBag()
    let projectId: String

    // MARK: View Model Inputs & Outputs
    //sourcery: output=Project
    private let project = ReplaySubject<Project>.create(bufferSize: 1)

    // MARK: Initializer
    init(project: Project) {
        input = Input()
        output = Output(project: self.project.asDriver(onErrorDriveWith: .empty()))

        projectId = project.id
        self.project.on(.next(project))

        observe()
    }

    // MARK: Methods
    private func observe() {}
}
