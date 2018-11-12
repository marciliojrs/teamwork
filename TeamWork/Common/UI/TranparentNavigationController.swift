import UIKit

class TransparentNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        hero.modalAnimationType = .none
    }
}
