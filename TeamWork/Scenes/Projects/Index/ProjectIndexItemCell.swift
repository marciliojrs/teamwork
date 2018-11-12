import UIKit
import RxSwift
import RxCocoa

final class ProjectIndexItemCell: UITableViewCell {
    @objc private var containerView: UIView!

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
