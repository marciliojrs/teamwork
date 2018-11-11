import RxSwift
import Domain

protocol ProjectRepositoryType: Domain.ProjectRepositoryType, AutoRequestable {
    var networkMaker: NetworkRequestMakerType! { get }

    //sourcery: method="get"
    //sourcery: path="projects.json"
    //sourcery: responseType=[TeamworkAPI.Project]
    //sourcery: domainMapping
    //sourcery: keyPath="projects"
    func all() -> Observable<[Domain.Project]>

    //sourcery: method="get"
    //sourcery: path="projects/\(id)/.json"
    //sourcery: responseType=TeamworkAPI.Project
    //sourcery: domainMapping
    //sourcery: keyPath="project"
    func project(by id: String) -> Observable<Domain.Project>
}
