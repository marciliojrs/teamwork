import Foundation
import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let rootViewController = viewControllers.last {
            return rootViewController.preferredStatusBarStyle
        }

        return super.preferredStatusBarStyle
    }
}
