//
//  IWBaseViewModel.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/5/26.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(iOS)
import UIKit

public class IWListViewDataSource: NSObject {
    
    open func _numberOfRows(in section: Int) -> Int {
        return 0
    }
    
    open var _numberOfSections: Int {
        return 0
    }
    
    open func _cell(forRowAt indexPath: IndexPath, with tableView: UITableView) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension IWListViewDataSource: UITableViewDataSource {
    
    final public func numberOfSections(in tableView: UITableView) -> Int {
        return _numberOfSections
    }
    final public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _numberOfRows(in: section)
    }
    final public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _cell(forRowAt: indexPath, with: tableView)
    }
}

public class IWListViewSigleSectionDataSourceBridge: IWListViewDataSource {

    public override var _numberOfSections: Int {
        return 1
    }

}

public class IWListViewDataSourceBridge: IWListViewDataSource {
    
    public var _baseViewModel: IWViewModel!
    
    public init(_ viewModel: IWViewModel) {
        _baseViewModel = viewModel
    }
    public func update(viewModel: IWViewModel) {
        _baseViewModel = viewModel
    }
    
    public override var _numberOfSections: Int {
        return _baseViewModel.numberOfSections
    }
    public override func _numberOfRows(in section: Int) -> Int {
        return _baseViewModel.numberOfRows(in: section)
    }
    
}

public class IWListViewSigleSectionDataSource: IWListViewDataSourceBridge {
    
    public override var _numberOfSections: Int { return 1 }
    
}

public class IWListViewMoreSectionDataSource: IWListViewDataSourceBridge {
    
    public override var _numberOfSections: Int { return _baseViewModel.numberOfSections }
    
}

#endif
