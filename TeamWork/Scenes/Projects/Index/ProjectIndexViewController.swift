import UIKit
import NVActivityIndicatorView

final class ProjectIndexViewController: BaseViewController<ProjectIndexViewModel> {
    override var layout: LayoutFile? { return R.file.projectIndexViewXml }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    override var prefersStatusBarHidden: Bool { return statusBarShoudBeHidden }

    @objc private weak var tableView: UITableView!
    @objc private weak var indicatorView: NVActivityIndicatorView!

    private let adapter = ProjectListAdapter()
    private var statusBarShoudBeHidden = false {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = R.string.localizable.projectsListTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        statusBarShoudBeHidden = false
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
            viewModel.output.projects.drive(adapter.rx.updateItems),
            viewModel.output.isLoading.drive(onNext: { [indicatorView] (isLoading) in
                isLoading ? indicatorView?.startAnimating() : indicatorView?.stopAnimating()
            })
        ]
    }

    override func bindOutlets() {
        bag << adapter.rx.itemSelected
            .do(onNext: { [unowned self] (_) in
                self.statusBarShoudBeHidden = true
            }).bind(to: viewModel.input.projectSelected)
    }
}
