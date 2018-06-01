//  Created by iWe on 2017/7/3.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public class IWLoginVC: IWRootVC {
    
    lazy var titleLabel: UILabel = {
        return IWLoginConst.titleLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        return IWLoginConst.descriptionLabel
    }()
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var showLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.init(name: "PingFangSC-Medium", size: 28)
        lb.textColor = .black
        lb.textAlignment = .center
        lb.backgroundColor = .white
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    var textFieldCharCount: Int = 6 {
        willSet {
            if newValue == 6 {
                showLabel.text = "-   -   -    -   -   -"
            } else {
                var tempstr = ""
                for _ in 0..<newValue {
                    tempstr += "-   "
                }
                showLabel.text = tempstr.removeLastCharacter.removeLastCharacter.removeLastCharacter
            }
        }
    } // textField 可输入几个字符
    
    lazy var helpButton: UIButton = {
        let btn = UIButton()
        IWLoginConst.nobackgroundButton(btn)
        btn.setTitle("帮助", for: .normal)
        return btn
    }()
    
    var navLeftCancelItem: UIBarButtonItem!
    var navRightActivityView: UIActivityIndicatorView!
    
    // Currently is verifying?
    var isVerifying: Bool = false

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public override func setupUserInterface() {
        
        isHideBackItemTitleWhenPushed = true
        
        // 设置视图
        setUpView()
        
        // 取消按钮
        let cancelItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(navCancelItemAction))
        cancelItem.tintColor = .defaultOfButton
        navigationItem.leftBarButtonItem = cancelItem
        navLeftCancelItem = cancelItem
        
        // 等待视图
        let activityIndicatorItem = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorItem)
        navRightActivityView = activityIndicatorItem
        
        // 设置信息
        setInfomations()
    }
    
    deinit {
        print("111111111111")
    }
    
    @objc func navCancelItemAction() {
        dismiss()
    }
    
    func setUpView() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(inputTextField)
        view.addSubview(showLabel)
        view.addSubview(helpButton)
        
        descriptionLabel.frame = CGRect(x: 20, y: titleLabel.bottom + 30, width: .screenWidth - 40, height: 42)
        
        inputTextField.frame = CGRect(x: 20, y: descriptionLabel.bottom + 40, width: .screenWidth - 40, height: 28)
        showLabel.frame = CGRect(x: inputTextField.x, y: inputTextField.y, width: inputTextField.width, height: inputTextField.height)
        showLabel.iwe.addTapGesture(target: self, action: #selector(inputTextfieldGetsTheFocus))
        
        helpButton.frame = CGRect(x: 20, y: showLabel.bottom + 30, width: .screenWidth - 20, height: 42)
        helpButton.addTarget(self, action: #selector(helpAction), for: .touchUpInside)
    }
    
    @objc func inputTextfieldGetsTheFocus() {
        inputTextField.becomeFirstResponder()
    }
    
    func setInfomations() {
        titleLabel.text = "双重认证"
        descriptionLabel.text = "一条包含验证码的信息已发送至您的受信任设备。输入验证码以继续。"
        
        inputTextField.text = ""
        inputTextField.delegate = self
        inputTextField.becomeFirstResponder()
        
        helpButton.setTitle("没有收到验证码？", for: .normal)
        
        textFieldCharCount = 6
    }
    
    @objc func helpAction() {
        
    }
    
    func verifying() {
        
        isVerifying = true
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        helpButton.isEnabled = false
        navRightActivityView.startAnimating()
		
		iw.delay.execution(delay: 3.0) {
			self.verifyCompleted()
		}
    }
    func verifyCompleted() {
        
        isVerifying = false
        navigationItem.leftBarButtonItem = navLeftCancelItem
        helpButton.isEnabled = true
        
        inputTextField.text = ""
        let temp = textFieldCharCount
        textFieldCharCount = temp
        
        navRightActivityView.stopAnimating()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension IWLoginVC: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if isVerifying {
            return false
        }
        
        if string == "" {
            // Delete
            handlerDeleteCharacter()
            return true
        }
        
        if textField.text!.count < textFieldCharCount {
            // Input
            handlerInputCharacter(input: string)
            
            // Input completed
            if textField.text!.count + 1 == textFieldCharCount {
                verifying()
            }
            return true
        }
        return false
    }
    
    func handlerDeleteCharacter() {
        let txt = showLabel.text!.removeSpace
        if txt.count > 0 {
            var tempstr = ""
            for i in txt.enumerated().reversed() {
                if i.element.description != "-" {
                    let nstxt: NSString = txt as NSString
                    tempstr = nstxt.replacingCharacters(in: NSMakeRange(i.offset, 1), with: "-") as String
                    break
                }
            }
            
            var addspacestr = ""
            for i in tempstr.enumerated() {
                if textFieldCharCount == 6 && i.offset == 2 {
                    addspacestr += i.element.description + "    "
                } else {
                    if i.offset != tempstr.count {
                        addspacestr += i.element.description + "   "
                    }
                }
            }
            showLabel.text = addspacestr
        }
    }
    
    func handlerInputCharacter(input string: String) {
        let txt = showLabel.text!
        let range = txt.range(of: "-")
        if let findRange = range {
            showLabel.text = txt.replacingCharacters(in: findRange, with: string)
        }
    }
}
