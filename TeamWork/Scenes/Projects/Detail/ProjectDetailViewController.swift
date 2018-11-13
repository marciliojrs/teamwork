import UIKit
import Hero
import RxGesture

final class ProjectDetailViewController: BaseViewController<ProjectDetailViewModel>, UIGestureRecognizerDelegate {
    override var layout: LayoutFile? { return R.file.projectDetailViewXml }
    override var initialViewState: ViewState {
        return ["name": "", "image": nil, "description": "", "titleColor": UIColor.black]
    }

    @objc private weak var cardView: UIView!
    @objc private weak var contentView: UIView!
    @objc private weak var visualEffectView: UIVisualEffectView!
    @objc private weak var scrollView: UIScrollView!
    @objc private weak var closeButton: UIButton!
    @objc private weak var logoImageView: TWKImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        hero.modalAnimationType = .none

        setupHero(for: viewModel.projectId)

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        gesture.delegate = self
        scrollView.addGestureRecognizer(gesture)
    }

    override func layoutLoad() {
        bag << logoImageView.rx.observe(UIColor.self, "primaryColor")
            .map { (primaryColor) in ["titleColor": (primaryColor ?? .black).brightnessAdjustedColor] }
            .bind(to: rx.state)

        bag << [
            viewModel.output.project.map {
                ["name": $0.name,
                 "image": $0.logo,
                 "description": "\($0.description)\n\($0.description)\n\($0.description)"]
            }.drive(rx.state)
        ]
    }

    override func bindOutlets() {
        bag << [closeButton.rx.tap.bind(to: viewModel.input.close)]
    }

    private func setupHero(for projectId: String) {
        cardView.hero.id = "card\(projectId)"
        cardView.hero.modifiers = [.spring(stiffness: 250, damping: 25)]
        visualEffectView.hero.modifiers = [.fade]
        scrollView.hero.modifiers = [.source(heroID: "card\(projectId)"),
                                     .spring(stiffness: 250, damping: 25)]
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            Hero.shared.update(translation.y / view.bounds.height)
        default:
            let velocity = gesture.velocity(in: view)
            if ((translation.y + velocity.y) / view.bounds.height) > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return scrollView.contentOffset.y <= 0
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
