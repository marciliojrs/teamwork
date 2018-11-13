import UIKit
import Hero
import RxGesture

final class ProjectDetailViewController: BaseViewController<ProjectDetailViewModel> {
    override var layout: LayoutFile? { return R.file.projectDetailViewXml }
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }

    override var initialViewState: ViewState {
        return ["name": "", "image": nil, "description": ""]
    }

    @objc private weak var cardView: UIView!
    @objc private weak var contentView: UIView!
    @objc private weak var visualEffectView: UIVisualEffectView!
    @objc private weak var scrollView: UIScrollView!
    @objc private weak var closeButton: UIButton!
    @objc private weak var logoImageView: TWKImageView!

    override func layoutLoad() {
        setupHero(for: viewModel.projectId)
        setupPanGestureToDismiss()

        bag << [
            viewModel.output.project.map {
                ["name": $0.name,
                 "image": $0.logo,
                 "description": $0.description]
            }.drive(rx.state)
        ]
    }

    private func setupPanGestureToDismiss() {
        let panGesture = scrollView.rx.panGesture { [scrollView] (_, delegate) in
            delegate.beginPolicy = .custom { _ in scrollView!.contentOffset.y <= 0 }
            delegate.simultaneousRecognitionPolicy = .always
        }.share(replay: 1, scope: .whileConnected)

        bag << panGesture.subscribe(onNext: { [unowned self] (gesture) in
            let translation = gesture.translation(in: self.view)
            switch gesture.state {
            case .began:
                self.dismiss(animated: true, completion: nil)
            case .changed:
                Hero.shared.update(translation.y / self.view.bounds.height)
            default:
                let velocity = gesture.velocity(in: self.view)
                if ((translation.y + velocity.y) / self.view.bounds.height) > 0.5 {
                    Hero.shared.finish()
                } else {
                    Hero.shared.cancel()
                }
            }
        })
    }

    override func bindOutlets() {
        bag << [closeButton.rx.tap.bind(to: viewModel.input.close)]
    }

    private func setupHero(for projectId: String) {
        hero.isEnabled = true
        hero.modalAnimationType = .none

        cardView.hero.id = "card\(projectId)"
        cardView.hero.modifiers = [.spring(stiffness: 250, damping: 25)]
        visualEffectView.hero.modifiers = [.fade]
        closeButton.superview?.hero.modifiers = [.fade]
        scrollView.hero.modifiers = [.source(heroID: "card\(projectId)"),
                                     .spring(stiffness: 250, damping: 25)]
    }
}
