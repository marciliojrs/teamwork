import UIKit

extension UIColor {
    var brightnessAdjustedColor: UIColor {
        var components = cgColor.components
        let alpha = components?.last
        components?.removeLast()
        let color = CGFloat(1 - (components?.max())! >= 0.5 ? 1.0 : 0.0)
        return UIColor(red: color, green: color, blue: color, alpha: alpha!)
    }
}
