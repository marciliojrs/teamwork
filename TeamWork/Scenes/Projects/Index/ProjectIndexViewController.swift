import UIKit

final class ProjectIndexViewController: BaseViewController<ProjectIndexViewModel> {
    override var layout: LayoutFile? { return R.file.projectIndexViewXml }

    @objc private weak var tableView: UITableView!
    private let adapter = ProjectListAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.localizable.projectsListTitle()
    }

    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes
            = [NSAttributedString.Key.foregroundColor: UIColor.black]

        navigationController?.navigationBar.installBlurEffect()
    }

    override func layoutLoad() {
        adapter.attach(listView: tableView)
        bag << [
            viewModel.output.projects.drive(adapter.rx.updateItems)
        ]
    }

    override func bindOutlets() {
        bag << adapter.rx.itemSelected.bind(to: viewModel.input.projectSelected)
    }
}
