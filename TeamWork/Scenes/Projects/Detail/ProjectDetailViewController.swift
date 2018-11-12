import UIKit

final class ProjectDetailViewController: BaseViewController<ProjectDetailViewModel> {
    override var layout: LayoutFile? { return R.file.projectDetailViewXml }
    override var initialViewState: ViewState {
        return ["name": "", "image": nil, "description": ""]
    }

    @objc private weak var cardView: UIView!
    @objc private weak var contentView: UIView!
    @objc private weak var visualEffectView: UIVisualEffectView!
    @objc private weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHero(for: viewModel.projectId)
    }

    override func layoutLoad() {
        bag << [
            viewModel.output.project.map {
                ["name": $0.name,
                 "image": $0.logo,
                 "description": $0.description]
            }.drive(rx.state)
        ]
    }

    private func setupHero(for projectId: String) {
        cardView.hero.id = "card\(projectId)"
        cardView.hero.modifiers = [.spring(stiffness: 250, damping: 25)]
        visualEffectView.hero.modifiers = [.fade]
        contentView.hero.modifiers = [.forceAnimate, .spring(stiffness: 250, damping: 25)]
        scrollView.hero.modifiers = [.source(heroID: "card\(projectId)"),
                                     .spring(stiffness: 250, damping: 25)]
    }
}
