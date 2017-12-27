//http://codepany.com/blog/swift-3-custom-uitextfield-with-single-line-input/
import UIKit

extension UITextField {
    func setBottomLine(in borderColor: UIColor) {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height + 4, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
}
