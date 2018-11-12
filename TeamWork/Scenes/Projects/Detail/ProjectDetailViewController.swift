import UIKit

final class ProjectDetailViewController: BaseViewController<ProjectDetailViewModel> {
    override var layout: LayoutFile? { return R.file.projectDetailViewXml }
    override var initialViewState: ViewState {
        return ["image": nil]
    }

    override func layoutLoad() {
        bag << [
            viewModel.output.project.map { ["image": $0.logo] }.drive(rx.state)
        ]
    }
}
