//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

fileprivate let kEstimatedProgress = "estimatedProgress"

open class IWWebVC: IWSubVC {
    
    public var web: IWWebView!
    public var progressView: UIProgressView!
    
    /// 当前请求地址
    public var requestURLString: String?
    
//    /// 当前是否显示了工具栏
//    private var isShowActionTools: Bool = false
//    /// 工具栏
//    private lazy var actionToolsView: UIView = { [unowned self] in
//        let v = UIView()
//        v.backgroundColor = UIColor.white
//        return v
//    }()
    
//    lazy var statusBackgroundView: UIView = self.initStatusBackgroundView()
//    lazy var statusBackItem: IWStatusBackItem = { [unowned self] in
//        let bi = IWStatusBackItem(tips: "返回", tapHandler: { [weak self] in
//            self?.hide()
//        })
//        return bi
//    }()
    
    /// 下拉显示当前网页域名/提供商
    private var hostInfoLabel: UILabel = UILabel()
    
    public typealias NavigationHandler = ((_ webView: IWWebView, _ navigation: WKNavigation?) -> Void)
    private var didStartHandler: NavigationHandler?
    private var loadFinishedHandler: NavigationHandler?
    
    /// (开始加载回调).
    public func setDidStart(_ handler: NavigationHandler?) -> Void {
        self.didStartHandler = handler
    }
    /// (加载完毕回调).
    public func setLoadFinished(_ handler: NavigationHandler?) -> Void {
        self.loadFinishedHandler = handler
    }
    
    /// (推荐初始化方式).
    convenience init(url: String) {
        self.init()
        self.requestURLString = url
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        web.stopLoading()
    }
    
    deinit {
        web.removeObserver(self, forKeyPath: kEstimatedProgress)
    }
    
    open override func preconfiguration() {
        navigationItemTitle = "正在加载..."
    }
    
    open override func setupUserInterface() {
        setupWebView()
        setupProgressView()
    }
    
    open override func configureUserInterface() {
        
        if iw.system.version.toDouble < 11.0 {
            web.scrollView.iwe.bothInsets = MakeEdge(.navBarHeight, 0, 0, 0)
        }
        
        requestURLString?.toURLRequest.unwrapped({ web.load($0) })
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// (处理进度条事件).
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == kEstimatedProgress {
            progressAnimation()
        }
    }
    
}

/// MARK:- Private Func / Function
extension IWWebVC {
    
    /// 展示 默认 风格
    private func showDefaultStyle() -> Void {
        // add host info label
        setupHostInfoLabel()
    }
    
//    /// 展示 mini 风格
//    private func showMiniStyle() -> Void {
//        // add back item to status
//        statusBackItem.show()
//
//        // reset host info label's frame
//        hostInfoLabel.y = .navBarHeight
//
//        // hide navigation bar
//        self.hideNavigationBar()
//
//        // add status background view
//        statusBackgroundView.backgroundColor = view.backgroundColor
//        view.addSubview(statusBackgroundView)
//
//        // reset progress view
//        progressView.top = statusBackgroundView.bottom
//
//        // reset edge insets
//        if iw.system.version.toDouble < 11.0 {
//            web.scrollView.iwe.autoSetEdge(view)
//        }
//
//        // add host info label
//        setupHostInfoLabel()
//    }
//    /// mini 模式下的返回按钮
//    private func hide() -> Void {
//        showNavigationBar()
//        pop()
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
//            self.statusBackItem.alpha = 0
//        }) { (finished) in
//            self.statusBackItem.tapHandler = nil
//            self.statusBackItem.removeFromSuperview()
//        }
//    }
    
    /// 进度条动画
    private func progressAnimation() -> Void {
        // Progress
        let newProgress = Float(web.estimatedProgress)
        if newProgress >= 1.0 {
            progressView.setProgress(1.0, animated: true)
            return
        }
        progressView.setProgress(newProgress, animated: true)
    }
    /// 加载时显示进度条
    private func showProgress() {
        progressView.alpha = 1
        progressView.isHidden = false
    }
    /// 加载完成后隐藏进度条
    private func hideProgress() {
        iw.delay.execution(delay: 0.5, toRun: {
            UIView.IWE.animation(0.5, {
                self.progressView.alpha = 0
            }, { (finished) in
                if finished {
                    self.progressView.isHidden = true
                    self.progressView.setProgress(0, animated: false)
                }
            })
        })
    }
    
    /// 是否为空白页面
    private func isBlankPage(_ webView: WKWebView) -> Bool {
        return webView.url!.absoluteString == "about:blank"
    }
    
    private func hideBackgroundColor() -> Void {
        web.backgroundColor = .clear
        web.iwe.wkContentView?.backgroundColor = .clear
        iw.delay.execution(delay: 0.5) {
            self.hostInfoLabel.isHidden = false
        }
    }
    private func showBackgroundColor() -> Void {
        hostInfoLabel.isHidden = true
        web.backgroundColor = .white
        web.iwe.wkContentView?.backgroundColor = .white
    }
    
}

/// MARK:- Private Func / Initalize
extension IWWebVC {
    
    private func initStatusBackgroundView() -> UIView {
        return IWStatus.bgView()
    }
    
    private func setupWebView() -> Void {
        web = IWWebView()
        web.navigationDelegate = self
        web.uiDelegate = self
        showBackgroundColor()
        view.addSubview(web)
        
        // 添加进度条监控
        web.addObserver(self, forKeyPath: kEstimatedProgress, options: .new, context: nil)
        
        setupLayoutToWebView()
    }
    private func setupLayoutToWebView() -> Void {
        web.translatesAutoresizingMaskIntoConstraints = false
        // Add layout
        let topConstraint = NSLayoutConstraint.init(item: web, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint.init(item: web, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: web, attribute: .trailing, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: web, attribute: .bottom, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
    }
    
    private func setupProgressView() -> Void {
        progressView = UIProgressView()
        progressView.trackTintColor = view.backgroundColor
        progressView.progressTintColor = .black
        progressView.progress = 0
        view.addSubview(progressView)
        
        setupLayoutToProgressView()
    }
    private func setupLayoutToProgressView() -> Void {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint.init(item: progressView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint.init(item: progressView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: progressView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint.init(item: progressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 2)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, heightConstraint])
    }
    
    private func setupHostInfoLabel() -> Void {
        hostInfoLabel.numberOfLines = 1
        hostInfoLabel.font = UIFont.init(name: "Menlo-Regular", size: 10)
        hostInfoLabel.textColor = "#a9a9a9".toColor
        hostInfoLabel.textAlignment = .center
        hostInfoLabel.isHidden = true
        view.insertSubview(hostInfoLabel, at: 0)
        
        setupLayoutToInfoLabel()
    }
    private func setupLayoutToInfoLabel() -> Void {
        hostInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint.init(item: hostInfoLabel, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 20)
        let leftConstraint = NSLayoutConstraint.init(item: hostInfoLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: hostInfoLabel, attribute: .trailing, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint.init(item: hostInfoLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 18)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, heightConstraint])
    }
}

extension IWWebVC: WKNavigationDelegate, WKUIDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        guard !isBlankPage(webView) else { iPrint("about:blank 不加载."); return }
        
        showProgress()
        
        iPrint("访问: \(webView.url!.absoluteString)")
        
        // add background color, until did finish clear
        showBackgroundColor()
        
        if let host = webView.url?.host {
            hostInfoLabel.text = "该网页由 \(host) 提供"
        } else {
            hostInfoLabel.text = "未能识别此域名"
        }
        
        // start handler
        didStartHandler?(web, navigation)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // set navigation bar title
        navigationItemTitle = webView.title
        
        // Handler background color
        hideBackgroundColor()
        
        // load finished
        loadFinishedHandler?(web, navigation)
        
        hideProgress()
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 处理新建标签页
        navigationAction.targetFrame.on(none: { webView.load(navigationAction.request) })
        decisionHandler(.allow)
    }
}


// MARK:- Alert
extension IWWebVC {
    
    //Alert弹框
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "好的", style: .cancel) { (_) in
            completionHandler()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //confirm弹框
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { (_) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (_) in
            completionHandler(false)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //TextInput弹框
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        alert.addTextField { (_) in}
        let action = UIAlertAction(title: "确定", style: .default) { (_) in
            completionHandler(alert.textFields?.last?.text)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

