import RxSwift
import Domain

protocol ProjectRepositoryType: Domain.ProjectRepositoryType, AutoRequestable {
    var networkMaker: NetworkRequestMakerType! { get }

    //sourcery: method="get"
    //sourcery: path="projects.json"
    //sourcery: responseType=[TeamworkAPI.Project]
    //sourcery: domainMapping
    //sourcery: keyPath="projects"
    //sourcery: headers=["Authorization": "Basic \("twp_ocsj8PR64FIV48fHVXCy75gBruca:X".base64.safe)"]
    func all() -> Observable<[Domain.Project]>

    //sourcery: method="get"
    //sourcery: path="projects/\(id)/.json"
    //sourcery: responseType=TeamworkAPI.Project
    //sourcery: domainMapping
    //sourcery: keyPath="project"
    //sourcery: headers=["Authorization": "Basic \("twp_ocsj8PR64FIV48fHVXCy75gBruca:X".base64.safe)"]
    func project(by id: String) -> Observable<Domain.Project>
}
