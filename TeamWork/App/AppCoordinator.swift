import Foundation
import UIKit
import URLNavigator
import RxSwift

final class AppCoordinator {
    private let bag = DisposeBag()

    init(window: UIWindow, navigator: NavigatorType) {
        let viewController = navigator.viewController(for: "tw://projects")!
        window.rootViewController = TransparentNavigationController(rootViewController: viewController)
    }
}
