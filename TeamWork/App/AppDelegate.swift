import UIKit
import URLNavigator
import IQKeyboardManagerSwift
import struct Layout.LayoutConsole

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private lazy var navigator: NavigatorType = Navigator()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setupWindowAndRoutes()
        setupAppearanceAndUiTools()
        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
        return true
    }

    private func setupWindowAndRoutes() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()

        Route.initialize(navigator: navigator)
        appCoordinator = AppCoordinator(window: window!, navigator: navigator)
    }

    private func setupAppearanceAndUiTools() {
        Appearance.install()
        LayoutConsole.isEnabled = true

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
}
