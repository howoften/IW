//  Created by iWe on 2017/7/4.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

/// (IWLoginVC 中的常量(函数)内容).
public class IWLoginConst: NSObject {
    
    public static let buttonFontSize: Float = 17.0
    
    public class var titleLabel: UILabel {
        let lb = UILabel()
        lb.frame = CGRect(x: 20, y: .navBarHeight + 15, width: .screenWidth - 40, height: 42)
        lb.text = "请输入标题"
        lb.font = .boldSystemFont(ofSize: 32)
        lb.textColor = .black
        lb.textAlignment = .center
        return lb
    }
    
    public class var descriptionLabel: UILabel {
        let lb = UILabel()
        lb.text = "描述内容"
        lb.font = .systemFont(ofSize: 14)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = 2
        lb.adjustsFontSizeToFitWidth = true
        lb.frame = CGRect(x: 20, y: 0, width: .screenWidth - 40, height: 42)
        return lb
    }
    
    public class func nobackgroundButton(_ btn: UIButton) {
        btn.config { (sender) in
            sender.titleColor(.defaultOfButton, .normal)
            sender.titleColor(UIColor.defaultOfButton.alpha(0.4), .highlighted)
            sender.titleColor(.gray, .disabled)
            
            sender.fontSize = buttonFontSize
            sender.titleAlignment = .center
        }
    }
    
    public class func backgroundButton(_ btn: UIButton) {
        btn.config { (sender) in
            sender.titleColor(.white, .normal)
            sender.titleColor(UIColor.white.alpha(0.4), .highlighted)
            
            sender.fontSize = buttonFontSize
            sender.titleAlignment = .center
            sender.backgroundColor = .defaultOfButton
        }
    }
}

