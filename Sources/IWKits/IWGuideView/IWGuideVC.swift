//  Created by iWw on 2018/6/6.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(iOS)
import UIKit

class IWGuideVC: IWRootVC {
    
    lazy var scrollView: UIScrollView = _initScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setupUserInterface() {
        view.addSubview(scrollView)
        
        if let navC = self.navigationController {
            navC.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        }
    }
    override func configureUserInterface() {
        configScrollView()
    }
    
    @objc func back() -> Void {
        self.dismiss()
    }
    
    private func _initScrollView() -> UIScrollView {
        var _frame = self.view.bounds
        _frame.width = _frame.width - 40
        _frame.x = 20
        let _sv = UIScrollView(frame: _frame)
        return _sv
    }
    private func configScrollView() {
//        scrollView.delegate = self
        scrollView.clipsToBounds.disable()
        scrollView.layer.masksToBounds.disable()
        
        let _subViewWidth = view.width - 40
        for i in 0 ... 4 {
            let _subView = UIView(frame: MakeRect(i.toCGFloat * (_subViewWidth), 0, _subViewWidth, view.height))
            _subView.backgroundColor = IWColor.random
            scrollView.addSubview(_subView)
        }
        
        scrollView.contentSize = MakeSize(5 * _subViewWidth, view.height)
        
        scrollView.isScrollEnabled.enable()
        scrollView.isPagingEnabled.enable()
    }
    
}
#endif
