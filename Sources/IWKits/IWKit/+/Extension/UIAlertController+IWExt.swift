//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension UIAlertController {
    
    public class func show(_ title: String? = "提示", message: String?, config: ((_ alert: UIAlert) -> Void)?) -> Void {
        UIAlert.alert(title: title, message: message, config: config)
    }
    
    public class func showInternetError(_ error: Error? = nil) {
        var msg = ""
        if let e = error {
            msg = e.localizedDescription
        } else {
            msg = "网络错误, 请稍后再试!"
        }
        UIAlert.alert(title: "提示", message: msg, config: nil)
    }
    
    public class func alert(title: String? = "提示", message: String?, config: ((_ alert: UIAlert) -> Void)?) -> Void {
        let alertController = UIAlert(title: title, message: message, preferredStyle: .alert)
        if config != nil {
            config!(alertController)
        } else {
            alertController.addConfirm(handler: nil)
        }
        alertController.show()
    }
    
    public func addCancel(title: String? = "取消", handler: ((_ action: UIAlertAction) -> Void)?) -> Void {
        let cancel = UIAlertAction(title: title, style: .cancel, handler: handler)
        addAction(cancel)
    }
    
    public func addConfirm(title: String? = "确定", style: UIAlertActionStyle = .default, handler: ((_ action: UIAlertAction) -> Void)?) -> Void {
        let confirm = UIAlertAction(title: title, style: style, handler: handler)
        addAction(confirm)
    }
    
    public func show() -> Void {
        UIViewController.IWE.current()?.present(self, animated: true, completion: nil)
    }
    
    public func setMessageAlignment(to alignment: NSTextAlignment) -> Void {
        if let containLabels = self.findContainLabelsView(self.view) {
            // 1 为内容, 0 为标题
            (containLabels[1] as? UILabel)?.textAlignment = alignment
        }
    }
    public func setTitleAlignment(to alignment: NSTextAlignment) -> Void {
        if let containLabels = self.findContainLabelsView(self.view) {
            // 1 为内容, 0 为标题
            (containLabels[0] as? UILabel)?.textAlignment = alignment
        }
    }
    /// 查找 UILabel
    private func findContainLabelsView(_ view: UIView) -> [UIView]? {
        for i in view.subviews {
            if i is UILabel {
                return view.subviews
            }
            if let resultV = self.findContainLabelsView(i) {
                return resultV
            }
        }
        return nil
    }
    
}
