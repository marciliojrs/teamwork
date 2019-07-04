@testable import TeamWork
@testable import Domain
import Nimble
import Quick
import RxSwift
import RxTest
import URLNavigator
import Foundation

class ProjectIndexViewModelSpec: QuickSpec {
    override func spec() {
        let navigator = NavigatorTypeMock()
        var useCase: GetAllProjectsUseCaseType!
        var scheduler: TestScheduler!
        var viewModel: ProjectIndexViewModel!

        describe("init") {
            beforeSuite {
                useCase = GetAllProjectsUseCaseTypeMock(projectRepository: ProjectRepositoryTypeMock())
            }
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
            }

            describe("GetAllProjectsUseCase execute") {
                context("when emit a valid response") {
                    let projectsArray = [Project.empty]
                    beforeEach {
                        (useCase as? GetAllProjectsUseCaseTypeMock)?.executeReturnValue = .just(projectsArray)
                        viewModel = ProjectIndexViewModel(navigator: navigator, getProjectsUseCase: useCase)
                        viewModel.input.didLoad.on(.next(()))
                    }

                    it("viewModel.output.projects should emit use case response") {
                        let observer = scheduler.record(viewModel.output.projects)
                        XCTAssertEqual(observer.events, [Recorded.next(0, projectsArray)])
                    }

                    it("viewModel.input.projectSelected should navigate to ProjectDetail") {
                        viewModel.input.projectSelected.on(.next(Project.empty))
                        expect(navigator.presentURLContextWrapFromAnimatedCompletionCalled).to(beTrue())
                    }
                }
                context("when emit an error") {
                    beforeEach {
                        (useCase as? GetAllProjectsUseCaseTypeMock)?.executeReturnValue = .error(DomainError.unknown)
                        viewModel = ProjectIndexViewModel(navigator: navigator, getProjectsUseCase: useCase)
                        viewModel.input.didLoad.on(.next(()))
                    }

                    it("viewModel.output.projects shouldn't emit values") {
                        let observer = scheduler.record(viewModel.output.projects)
                        let expected: [Recorded<Event<[Project]>>] = []
                        XCTAssertEqual(observer.events, expected)
                    }

                    it("viewModel.output.error should emit the error") {
                        let observer = scheduler.record(viewModel.output.error)
                        let expected: [Recorded<Event<DomainError>>] = [Recorded.next(0, DomainError.unknown)]
                        XCTAssertEqual(observer.events, expected)
                    }
                }
            }
        }
    }
}
