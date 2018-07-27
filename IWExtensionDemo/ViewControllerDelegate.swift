//
//  ViewControllerDelegate.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/5/24.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

class ViewControllerDelegate: NSObject {
    
    private var _viewModel: ViewControllerViewModel!
    init(_ vm: ViewControllerViewModel) {
        _viewModel = vm
    }
    
    private func showWave(with maskType: IWWaveLoadingView.MaskViewType) {
        iw.loading.showWaveLoading(withMaskType: maskType)
        iw.delay.execution(delay: 3) {
            iw.loading.stopWaveLoading()
        }
    }
}

extension ViewControllerDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (_viewModel.cellModel(with: indexPath) as? SubItemModel)?.acid {
        case "guidevc": do {
            let nav = IWNavController(rootViewController: IWGuideVC())
            UIViewController.current?.modal(nav)
        }
        case "naver":                               iw.naver.url("./NaverViewController?title=URL跳转解决方案")
        case "permissions":                         iw.naver.url("./PermissionsViewController")
        case "scanQR":                              iw.naver.url("./ScanQRViewController")
        case "generateQRCode":                      iw.naver.url("./QRCodeViewController")
        case "keychain":                            iw.naver.url("./KeyChainViewController")
        case "flowlayout":                          iw.naver.url("./CollectionViewLayoutViewController")
        case "storeProduct":                        iw.appstore.show(with: "1329879957") // Surge3 1329879957, Web Developer Tool
        case "showWave": do {
            iw.loading.showWaveLoading()
            iw.delay.execution(delay: 2, toRun: {
                iw.loading.stopWaveLoading()
            })
        }
        case "stopWave":                            iw.loading.stopWaveLoading()
        case "showWaveDark":                        self.showWave(with: .dark)
        case "showWaveLight":                       self.showWave(with: .light)
        case "showWaveTransparent":                 self.showWave(with: .transparent)
        case "login": do {
            UIViewController.current?.modal(IWLoginNavController())
        }
        default: break
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if iw.system.version.toDouble < 9.0 {
            return tableView.cacheHeight(with: indexPath, default: calcHeightForRowWithiOS8(indexPath))
        }
        return tableView.cacheHeight(with: indexPath, default: .estimated)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.save(cellHeight: cell.height, with: indexPath)
    }
    
    private func calcHeightForRowWithiOS8(_ indexPath: IndexPath) -> CGFloat {
        if let updateDesc = (_viewModel.cellModel(with: indexPath) as? SubItemModel)?.sub as NSString? {
            let height = updateDesc.boundingRect(with: MakeSize(.screenWidth - 20 - 36, .greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font: UIFont.init(name: "Menlo-Regular", size: 12)!], context: nil).size.height
            return height + 29 + 4 + 10
        }
        return 29 + 4 + 10
    }

    
}
