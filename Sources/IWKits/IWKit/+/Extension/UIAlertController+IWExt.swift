//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension UIAlertController {
    
    class func show(_ title: String? = "提示", message: String?, config: ((_ alert: UIAlert) -> Void)?) -> Void {
        UIAlert.alert(title: title, message: message, config: config)
    }
    
    class func showInternetError(_ error: Error? = nil) {
        var msg = ""
        if let e = error {
            msg = e.localizedDescription
        } else {
            msg = "网络错误, 请稍后再试!"
        }
        UIAlert.alert(title: "提示", message: msg, config: nil)
    }
    
    class func alert(title: String? = "提示", message: String?, config: ((_ alert: UIAlert) -> Void)?) -> Void {
        let alertController = UIAlert(title: title, message: message, preferredStyle: .alert)
        if config != nil {
            config!(alertController)
        } else {
            alertController.addConfirm(handler: nil)
        }
        alertController.show()
    }
    
    func addCancel(title: String? = "取消", handler: ((_ action: UIAlertAction) -> Void)?) {
        let cancel = UIAlertAction(title: title, style: .cancel, handler: handler)
        addAction(cancel)
    }
    
    func addConfirm(title: String? = "确定", style: UIAlertActionStyle = .default, handler: ((_ action: UIAlertAction) -> Void)?) {
        let confirm = UIAlertAction(title: title, style: style, handler: handler)
        addAction(confirm)
    }
    
    func show() {
        UIViewController.IWE.current()?.present(self, animated: true, completion: nil)
    }
}
