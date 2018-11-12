import Domain
import RxSwift
import RxCocoa

final class ProjectListAdapter: ListBaseAdapter<Project> {}

extension Reactive where Base: ProjectListAdapter {
    var updateItems: Binder<[Project]> {
        return Binder(self.base) { (target: ProjectListAdapter, value: [Project]) in
            target.update(items: value)
        }
    }
}
