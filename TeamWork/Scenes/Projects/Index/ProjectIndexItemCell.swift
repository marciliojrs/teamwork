import UIKit
import RxSwift
import RxCocoa

final class ProjectIndexItemCell: UITableViewCell {
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
}
