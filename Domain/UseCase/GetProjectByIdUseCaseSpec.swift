@testable import Domain
import RxSwift
import RxTest
import Quick
import Nimble

class GetProjectByIdUseCaseSpec: QuickSpec {
    override func spec() {
        var repository: ProjectRepositoryType!
        var useCase: GetProjectByIdUseCaseType!
        var scheduler: TestScheduler!
        var result: TestableObserver<Project>!

        describe("execute") {
            beforeSuite {
                repository = ProjectRepositoryTypeMock()
                useCase = GetProjectByIdUseCase(projectRepository: repository)
            }
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
            }

            context("when id is empty") {
                beforeEach {
                    result = scheduler.record(useCase.execute(id: ""))
                }

                it("should emit a validation error") {
                    XCTAssertEqual(result.events, [error(0, DomainError.validation(["id": "id cannot be empty"]))])
                }
            }

            context("when repository returns a valid response") {
                let retrieveResponse = Project.empty
                beforeEach {
                    (repository as? ProjectRepositoryTypeMock)?.projectByReturnValue = .just(retrieveResponse)
                    result = scheduler.record(useCase.execute(id: "12456"))
                }

                it("should emit a single event with a valid project") {
                    XCTAssertEqual(result.events, [next(0, retrieveResponse), completed(0)])
                }
            }

            context("when repository returns an invalid response") {
                beforeEach {
                    (repository as? ProjectRepositoryTypeMock)?.projectByReturnValue = .error(DomainError.unknown)
                    result = scheduler.record(useCase.execute(id: "12345"))
                }

                it("should emit an error") {
                    XCTAssertEqual(result.events, [error(0, DomainError.unknown)])
                }
            }
        }
    }
}
