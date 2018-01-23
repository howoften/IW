//  Created by iWe on 2017/9/28.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

class IWStatusBackItem: UIWindow {
	
	var baseView = UIView()
	var imageView = UIImageView()
	var image: UIImage? {
		if IWStatus.style == .default {
			// Black
			return IWBundle.shared.image("statusBackItem_black@2x")
		} else {
			// White
			return IWBundle.shared.image("statusBackItem_white@2x")
		}
	}
	var tipsLabel = UILabel()
	
	var tapHandler: (() -> Void)?
	var tips: String?
	
	init(tips: String = "返回", tapHandler: (() -> Void)?) {
		super.init(frame: .zero)
		self.tips = tips
		self.tapHandler = tapHandler
		
		initUserInterface()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		initUserInterface()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func initUserInterface() -> Void {
		windowLevel = UIWindowLevelAlert
		frame = MakeRect(0, 0, .screenWidth / 2 - 60, .statusBarHeight)
		backgroundColor = .white
		
		baseView.frame = frame
		baseView.backgroundColor = .white
		baseView.iwe.addTapGesture(target: self, action: #selector(tapAction))
		self.addSubview(baseView)
		
		imageView.image = image
		imageView.frame = MakeRect(10, (frame.height - 12) / 2, 12, 12)
		baseView.addSubview(imageView)
		
		tipsLabel.frame = MakeRect(imageView.right + 4, (frame.height - 12) / 2, (baseView.width - (imageView.right + 4)), 12)
		tipsLabel.text = tips ?? "返回"
		tipsLabel.font = UIFont.IWE.fontFamily("Menlo", type: .regular, size: 12)
		tipsLabel.textColor = .black
		baseView.addSubview(tipsLabel)
	}
	
	@objc func tapAction() -> Void {
		tapHandler?()
	}
	
	func show() -> Void {
		iwe.show()
	}
	
}
