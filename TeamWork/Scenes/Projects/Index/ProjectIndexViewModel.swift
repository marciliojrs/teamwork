import RxCocoa
import RxSwift
import Domain

struct ProjectIndexViewModel: RxViewModel {
    let input: ProjectIndexViewModel.Input
    let output: ProjectIndexViewModel.Output

    private let bag = DisposeBag()

    let getProjectsUseCase: Domain.GetAllProjectsUseCaseType

    // MARK: View Model Inputs & Outputs
    //sourcery: output=[Project]
    private let projects = ReplaySubject<[Project]>.create(bufferSize: 1)
    //sourcery: output=Bool
    private let isLoading = RxActivityTracker()
    //sourcery: output=Error
    private let error = RxErrorTracker()

    // MARK: Initializer
    init(getProjectsUseCase: Domain.GetAllProjectsUseCaseType) {
        input = Input()
        output = Output(
            projects: projects.asDriver(onErrorJustReturn: []),
            isLoading: isLoading.asDriver(),
            error: error.asDriver()
        )

        self.getProjectsUseCase = getProjectsUseCase
        observe()
    }

    // MARK: Methods
    private func observe() {
        bag << getProjectsUseCase.execute().asObservable()
            .track(activity: isLoading)
            .track(error: error)
            .debug()
            .bind(to: projects)
    }
}
