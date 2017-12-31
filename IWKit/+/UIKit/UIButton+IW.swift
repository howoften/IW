//
//  UIButton+IWView.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

extension IWView where View: UIButton {
	
	/// Set fontSize with systemFont
	final var fontSize: Float {
		get { return Float(view.titleLabel?.font.pointSize ?? 17.0)  }
		set { view.titleLabel?.font = .systemFont(ofSize: CGFloat(newValue)) }
	}
	
	
	/// Set title for normal
	final var title: String? {
		get { return view.titleLabel?.text }
		set { view.setTitle(newValue, for: .normal) }
	}
	
	/// Set titleColor for normal
	final var titleColor: UIColor? {
		get { return view.currentTitleColor }
		set { view.setTitleColor(newValue, for: .normal) }
	}
	
	final func titleColor(_ color: UIColor?, _ state: UIControlState = .normal) -> Void {
		view.setTitleColor(color, for: state)
	}
	
	/// Set titleLabel alignment
	final var titleAlignment: NSTextAlignment {
		get { return view.titleLabel?.textAlignment ?? .left }
		set { view.titleLabel?.textAlignment = newValue }
	}
	
	/// Set backgroundColor
	final func bgColor(_ color: UIColor) {
		view.backgroundColor = color
		titleColor(.white)
	}
	
}
