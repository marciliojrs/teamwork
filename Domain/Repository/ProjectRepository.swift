import RxSwift

public protocol ProjectRepositoryType: AutoMockable {
    func all() -> Observable<[Project]>
    func project(by id: String) -> Observable<Project>
}
