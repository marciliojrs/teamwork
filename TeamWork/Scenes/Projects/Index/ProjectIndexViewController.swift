import UIKit

final class ProjectIndexViewController: BaseViewController<ProjectIndexViewModel> {
    override var layout: LayoutFile? { return R.file.projectIndexViewXml }

    @objc private weak var tableView: UITableView!
    private let adapter = ProjectListAdapter()

    override func layoutLoad() {
        bag << [
            viewModel.output.projects.drive(adapter.rx.updateItems)
        ]
    }
}
