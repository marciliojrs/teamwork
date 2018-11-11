import UIKit

class AppTabBarController: UITabBarController {
    private var allControllers: [Int: UIViewController] = [:]
    private var state: [Int: Bool] = [:]

    func setAllViewControllers(_ viewControllers: [UIViewController]) {
        viewControllers.enumerated().forEach { (index, viewController) in
            allControllers[index] = viewController
            state[index] = true
        }

        self.viewControllers = viewControllers
    }

    func hideViewControllerIfPossible(at index: Int) {
        if state[index] == true {
            viewControllers?.remove(at: index)
            state[index] = false
        }
    }

    func showViewControllerIfPossible(at index: Int) {
        if let view = allControllers[index], state[index] == false {
            viewControllers?.insert(view, at: index)
            state[index] = true
        }
    }
}

class AppTabBarItem: UITabBarItem {
    convenience init(title: String, image: UIImage) {
        self.init(title: title, image: image, selectedImage: nil)
    }
}
