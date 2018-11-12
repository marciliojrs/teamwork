import UIKit
import RxSwift
import RxCocoa
import Hero

final class ProjectIndexItemCell: UITableViewCell {
    @objc private weak var containerView: UIView!
    @objc private weak var cardView: UIView!
    @objc private weak var logoImageView: UIImageView!

    private var isTouched: Bool = false {
        didSet {
            var transform = CGAffineTransform.identity
            if isTouched { transform = transform.scaledBy(x: 0.96, y: 0.96) }
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [],
                animations: { [containerView] in
                    containerView?.transform = transform
                }, completion: nil
            )
        }
    }

    public static func registerIntoList(_ listView: ListViewType?,
                                        state: ViewState,
                                        constants: [String: Any]? = nil,
                                        reuseIdentifier: String) {
        listView?.registerLayout(named: "ProjectIndexItemCell",
                                 bundle: Bundle.main,
                                 relativeTo: #file,
                                 state: state,
                                 constants: constants ?? [:],
                                 forCellReuseIdentifier: reuseIdentifier)
    }

    func setupHeroConstraints(for projectId: String) {
        cardView.hero.id = "card\(projectId)"
        cardView.hero.modifiers = [.spring(stiffness: 250, damping: 25)]
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouched = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouched = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouched = false
    }
}
