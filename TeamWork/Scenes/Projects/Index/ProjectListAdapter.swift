import Domain
import RxSwift
import RxCocoa

final class ProjectListAdapter: ListBaseAdapter<Project> {
    fileprivate let itemSelected = PublishSubject<Project>()

    override func attach(listView: ListViewType?) {
        super.attach(listView: listView)
        ProjectIndexItemCell.registerIntoList(listView,
                                              state: ["name": "",
                                                      "image": nil,
                                                      "company.name": "",
                                                      "description": "",
                                                      "titleColor": UIColor.black],
                                              reuseIdentifier: "ProjectIndexItemCell")
    }

    override func listView(_ listView: ListViewType, cellForItemAt indexPath: IndexPath) -> ListViewItemType {
        let project = items[indexPath.row]
        let node = listView.dequeueReusableCellNode(withIdentifier: "ProjectIndexItemCell", for: indexPath)
        //swiftlint:disable:next force_cast
        let cell = node.view as! ProjectIndexItemCell

        cell.setupHeroConstraints(for: project.id)
        cell.bag << cell.primaryColor
            .map { ($0 ?? .black).brightnessAdjustedColor }
            .subscribe(onNext: { node.setState(["titleColor": $0]) })

        node.setState([
            "name": project.name,
            "image": project.logo,
            "company.name": project.company.name,
            "description": project.description
        ])

        return cell
    }

    override func listView(_ listView: ListViewType, didSelectItemAt indexPath: IndexPath) {
        let project = items[indexPath.row]
        itemSelected.on(.next(project))
    }
}

extension Reactive where Base: ProjectListAdapter {
    var updateItems: Binder<[Project]> {
        return Binder(self.base) { (target: ProjectListAdapter, value: [Project]) in
            target.update(items: value)
        }
    }

    var itemSelected: Observable<Project> {
        return self.base.itemSelected
    }
}
