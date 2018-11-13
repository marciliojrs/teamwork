import Layout
import UIKit
import Kingfisher
import ObjectiveC

extension RuntimeType {
    @objc static let uiImageRenderingMode = RuntimeType([
        "alwaysOriginal": .alwaysOriginal,
        "alwaysTemplate": .alwaysTemplate,
        "automatic": .automatic
    ] as [String: UIImage.RenderingMode])
}

extension UIImageView {
    open override class var expressionTypes: [String: RuntimeType] {
        var types = super.expressionTypes
        types["imageUrl"] = .url
        types["renderingMode"] = .uiImageRenderingMode
        return types
    }

    open override func setValue(_ value: Any, forExpression name: String) throws {
        switch name {
        case "imageUrl":
            self.kf.setImage(with: value as? URL)
        case "renderingMode":
            let renderingMode = value as? UIImage.RenderingMode ?? .automatic
            self.image = image?.withRenderingMode(renderingMode)
        default:
            try super.setValue(value, forExpression: name)
        }
    }
}

class TWKImageView: UIImageView {
    @objc private(set) dynamic var primaryColor: UIColor?

    open override class var expressionTypes: [String: RuntimeType] {
        var types = super.expressionTypes
        types["imageUrl"] = .url
        return types
    }

    open override func setValue(_ value: Any, forExpression name: String) throws {
        switch name {
        case "imageUrl":
            self.kf.setImage(with: value as? URL,
                             placeholder: R.image.placeholder(),
                             completionHandler: { (image, _, _, _) in
                if let image = image {
                    DispatchQueue.global().async {
                        let colors = image.getColors()
                        DispatchQueue.main.async {
                            self.primaryColor = colors.secondary
                        }
                    }
                }
            })
        default:
            try super.setValue(value, forExpression: name)
        }
    }
}
