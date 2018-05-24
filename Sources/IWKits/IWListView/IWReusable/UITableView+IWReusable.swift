//  Created by iWe on 2017/9/6.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

extension UITableViewCell: IWNibReusable { }
extension UITableViewHeaderFooterView: IWNibReusable { }

public extension UITableView {
    
    private struct _IWKey {
        static var belongViewControllerKey: Void?
    }
    
}

// MARK:- Cell
public extension UITableView {
    
    // MARK: Regist reusable cell
    /// (注册复用Cell).
    final func registReusable<T: UITableViewCell>(_ cell: T.Type) {
        let name = String(describing: cell)
        let xibPath = Bundle.main.path(forResource: name, ofType: "nib")
        if let path = xibPath {
            let exists = FileManager.default.fileExists(atPath: path)
            if exists {
                register(cell.nib, forCellReuseIdentifier: cell.identifier)
            }
        } else {
            register(cell.self, forCellReuseIdentifier: cell.identifier)
        }
    }
    /// (从复用池取出Cell).
    final func reuseCell<T: UITableViewCell>(_ cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier ) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.identifier)")
        }
        return cell
    }
    /// (从复用池取出Cell).
    final func reuseCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.identifier)")
        }
        return cell
    }
    
    /// (TableView 所属 ViewController).
    public var belongViewController: UIViewController? {
        return _belongViewController
    }
    private var _belongViewController: UIViewController? {
        get { return objc_getAssociatedObject(self, &_IWKey.belongViewControllerKey) as? UIViewController }
        set { objc_setAssociatedObject(self, &_IWKey.belongViewControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension UITableView {
    open override func willMove(toSuperview newSuperview: UIView?) {
        self._belongViewController = newSuperview?.viewController
        super.willMove(toSuperview: newSuperview)
    }
}


// MARK:- Header footer view
public extension UITableView {
    
    // MARK: Regist reusable header footer
    /// (注册复用View).
    final func registReusable<T: UITableViewHeaderFooterView>(_ headerFooterView: T.Type = T.self) {
        let name = String(describing: headerFooterView)
        let xibPath = Bundle.main.path(forResource: name, ofType: "nib")
        if let path = xibPath {
            let exists = FileManager.default.fileExists(atPath: path)
            if exists {
                register(headerFooterView.nib, forHeaderFooterViewReuseIdentifier: headerFooterView.identifier)
            }
        } else {
            register(headerFooterView.self, forHeaderFooterViewReuseIdentifier: headerFooterView.identifier)
        }
    }
    /// (从复用池取出View).
    final func reuseHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type = T.self) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: type.identifier) as? T else {
            fatalError("Failed to dequeue a header footer view with identifier \(type.identifier)")
        }
        return view
    }
}

