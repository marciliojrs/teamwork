import URLNavigator
import Domain
import SafariServices

enum Route {
    static func initialize(navigator: NavigatorType) {
        registerAppRoutes(in: navigator)
    }
}

extension Route {
    private static func registerAppRoutes(in navigator: NavigatorType) {
        navigator.register("tw://projects") { (_, _, _) -> UIViewController? in
            let viewModel = ProjectIndexViewModel(navigator: navigator,
                                                  getProjectsUseCase: factory.makeGetAllProjects())
            let viewController = ProjectIndexViewController(viewModel: viewModel)
            return viewController
        }

        navigator.register("tw://project/<string:id>") { (_, values, context) -> UIViewController? in
//            guard let projectId = values["id"] as? String else { return nil }
            guard let project = context as? Project else { return nil }
            let viewModel = ProjectDetailViewModel(navigator: navigator, project: project)
            let viewController = ProjectDetailViewController(viewModel: viewModel)

            return viewController
        }
    }
}

extension NavigatorType {
    func goToPreviousScreen() {
        if let navigationController = UIViewController.topMost?.navigationController {
            navigationController.popViewController(animated: true)
        } else if let topMost = UIViewController.topMost {
            topMost.dismiss(animated: true, completion: nil)
        }
    }

    func dismissPresenting() {
        UIViewController.topMost?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func goToTab(_ index: Int) {
        UIViewController.topMost?.tabBarController?.selectedIndex = index
    }

    func hideTab(at index: Int) {
        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? AppTabBarController {
            tabController.hideViewControllerIfPossible(at: index)
        }
    }

    func showTab(at index: Int) {
        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? AppTabBarController {
            tabController.showViewControllerIfPossible(at: index)
        }
    }
}
