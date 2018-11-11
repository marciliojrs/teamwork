import Layout

extension LayoutLoading {
    var defaultConstants: LayoutConstants {
        return Font.layoutConstants.merging(UIColor.layoutConstants, uniquingKeysWith: { (lhs, _) in lhs })
    }

    func loadLayout(_ file: LayoutFile, state: ViewState, constants: LayoutConstants = [:]) {
        loadLayout(named: file.name, bundle: file.bundle, state: state, constants: defaultConstants, constants)
    }
}
