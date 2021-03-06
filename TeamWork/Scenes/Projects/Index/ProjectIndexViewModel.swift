import RxCocoa
import RxSwift
import Domain
import URLNavigator

struct ProjectIndexViewModel: RxViewModel {
    let input: ProjectIndexViewModel.Input
    let output: ProjectIndexViewModel.Output

    private let bag = DisposeBag()

    private let getProjectsUseCase: Domain.GetAllProjectsUseCaseType
    private let navigator: NavigatorType

    // MARK: View Model Inputs & Outputs
    //sourcery: input=Void
    private let didLoad = PublishSubject<Void>()
    //sourcery: input=Project
    private let projectSelected = PublishSubject<Project>()
    //sourcery: output=[Project]
    private let projects = ReplaySubject<[Project]>.create(bufferSize: 1)
    //sourcery: output=Bool
    private let isLoading = RxActivityTracker()
    //sourcery: output=DomainError
    private let error = RxErrorTracker()

    // MARK: Initializer
    init(navigator: NavigatorType, getProjectsUseCase: Domain.GetAllProjectsUseCaseType) {
        input = Input(didLoad: didLoad.asObserver(), projectSelected: projectSelected.asObserver())
        output = Output(
            projects: projects.asDriver(onErrorJustReturn: []),
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            error: error.asDriver()
        )

        self.navigator = navigator
        self.getProjectsUseCase = getProjectsUseCase

        observe()
    }

    // MARK: Methods
    private func observe() {
        bag << didLoad.flatMapLatest { [getProjectsUseCase, error, isLoading] _ in
            getProjectsUseCase.execute().asObservable()
                .track(activity: isLoading)
                .track(error: error)
        }.subscribe(onNext: projects.onNext)

        bag << projectSelected.subscribe(onNext: { [navigator] (project) in
            navigator.present("tw://project/\(project.id)", context: project)
        })
    }
}
