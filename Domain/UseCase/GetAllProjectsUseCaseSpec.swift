@testable import Domain
import RxSwift
import RxTest
import Quick
import Nimble

class GetAllProjectsUseCaseSpec: QuickSpec {
    override func spec() {
        var repository: ProjectRepositoryType!
        var useCase: GetAllProjectsUseCaseType!
        var scheduler: TestScheduler!
        var result: TestableObserver<[Project]>!

        describe("execute") {
            beforeSuite {
                repository = ProjectRepositoryTypeMock()
                useCase = GetAllProjectsUseCase(projectRepository: repository)
            }
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
            }

            context("when repository returns a valid response") {
                let retrieveResponse = [Project.empty, Project.empty]
                beforeEach {
                    (repository as? ProjectRepositoryTypeMock)?.allReturnValue = .just(retrieveResponse)
                    result = scheduler.record(useCase.execute())
                }

                it("should emit a single event with a valid projects list") {
                    XCTAssertEqual(result.events, [next(0, retrieveResponse), completed(0)])
                }
            }
            context("when repository returns an invalid response") {
                beforeEach {
                    (repository as? ProjectRepositoryTypeMock)?.allReturnValue = .error(DomainError.unknown)
                    result = scheduler.record(useCase.execute())
                }

                it("should emit an error") {
                    XCTAssertEqual(result.events, [error(0, DomainError.unknown)])
                }
            }
        }
    }
}
