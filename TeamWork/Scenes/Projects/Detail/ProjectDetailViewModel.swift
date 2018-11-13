import RxCocoa
import RxSwift
import Domain
import URLNavigator

struct ProjectDetailViewModel: RxViewModel {
    let input: ProjectDetailViewModel.Input
    let output: ProjectDetailViewModel.Output

    private let navigator: NavigatorType
    private let bag = DisposeBag()
    let projectId: String

    // MARK: View Model Inputs & Outputs
    //sourcery: input=Void
    private let close = PublishSubject<Void>()
    //sourcery: output=Project
    private let project = ReplaySubject<Project>.create(bufferSize: 1)

    // MARK: Initializer
    init(navigator: NavigatorType, project: Project) {
        input = Input(close: close.asObserver())
        output = Output(project: self.project.asDriver(onErrorDriveWith: .empty()))

        self.navigator = navigator
        projectId = project.id
        self.project.on(.next(project))

        observe()
    }

    // MARK: Methods
    private func observe() {
        bag << close.subscribe(onNext: { [navigator] _ in
            navigator.dismissPresenting()
        })
    }
}
