import UIKit

extension UIColor {
    convenience init?(hexColor: String) {
        var hexColor = String(hexColor.dropFirst())
        guard hexColor.count == 6 else {
            return nil
        }
        hexColor += "FF"
        var int32Color: UInt32 = 0
        guard Scanner(string: hexColor).scanHexInt32(&int32Color) else {
            return nil
        }
        self.init(
            red: CGFloat((int32Color & 0xff000000) >> 24) / 255.0,
            green: CGFloat((int32Color & 0x00ff0000) >> 16) / 255.0,
            blue: CGFloat((int32Color & 0x0000ff00) >> 8) / 255.0,
            alpha: 1
        )
    }
}
