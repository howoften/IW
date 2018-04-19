//
//  IWPermissions.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/4/3.
//  Copyright © 2018年 iWe. All rights reserved.
//

/**
 let status = PHPhotoLibrary.authorizationStatus()
 switch status {
 // 未操作
 // Explicit user permission is required for photo library access, but the user has not yet granted or denied such permission.
 // 用户权限是显式访问照片库所必需的，但用户尚未授予或拒绝此类权限。
 case .notDetermined: break
 
 // 无权限
 // Your app is not authorized to access the photo library, and the user cannot grant such permission.
 // 您的应用无权访问照片库，并且用户无法授予此类权限。(可能是家长控制)
 case .restricted: break
 
 // 拒绝访问
 // The user has explicitly denied your app access to the photo library.
 // 用户已明确拒绝您的应用访问照片库。
 case .denied: break
 
 // 通过授权
 // The user has explicitly granted your app access to the photo library.
 // 用户已明确授予您的应用访问照片库的权限。
 case .authorized: break
 
 */

import UIKit
// 相机，麦克风
import AVFoundation
// - 相机，麦克风

// 相册
import AssetsLibrary
import Photos
// - 相册

// 定位
import LocalAuthentication
// - 定位

// 通讯录
import Contacts             // iOS 9, after
import AddressBook          // iOS 9 - before
// - 通讯录

// 日历，备忘录
import EventKit
// - 日历，备忘录

// 媒体资料库/Apple Music
import MediaPlayer
// - 媒体资料库/Apple Music

// 健康
import HealthKit
// - 健康

public class IWPermissionsBase: NSObject {
    deinit {
        iPrint("\(self) is deinit.")
    }
}

public class IWPCamera: IWPermissionsBase {  }
public class IWPPhotoLibrary: IWPermissionsBase {  }
public class IWPLocation: IWPermissionsBase {  }
public class IWPMicrophone: IWPermissionsBase {  }
public class IWPContacts: IWPermissionsBase {  }
public class IWPCalendar: IWPermissionsBase {  }
public class IWPReminder: IWPermissionsBase {  }
public class IWPAppleMusic: IWPermissionsBase {  }
public class IWPHealth: IWPermissionsBase {  }

public class IWPermissionManager<T: IWPermissionsBase>: NSObject, CLLocationManagerDelegate {
    
    public enum AuthorizationType {
        case photoLibrary   // 相册
        case camera         // 相机
        case location       // 定位
        case microphone     // 麦克风
        case contacts       // 通讯录
        case calendar       // 日历
        case reminder       // 备忘录
        case appleMusic     // 音乐
        case health         // 健康
        case none
    }
    
    public enum AuthorizationStatus: Int {
        case notDetermined = 0      // 未操作
        case restricted = 1         // 无权限
        case denied = 2             // 拒绝
        case authorized = 3         // 通过
        case none = -1              // 无
        var description: String {
            switch self {
            case .authorized:
                return "已授权"
            case .notDetermined:
                return "未操作"
            case .restricted:
                return "无权限授权"
            case .denied:
                return "已拒绝"
            case .none:
                return "未知"
            }
        }
        
        func `is`(_ equal: AuthorizationStatus) -> Bool {
            return self == equal
        }
    }
    
    /// (授权回调).
    public typealias AuthorizedBlock = (_ authorizeThrough: Bool, _ authorizeStatus: AuthorizationStatus) -> Void
    private var authroizedHandler: AuthorizedBlock?
    
    private lazy var locationManager: CLLocationManager = { [unowned self] in
        let clm = CLLocationManager.init()
        clm.delegate = self
        return clm
    }()
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.authroizedHandler?(true, .authorized)
        case .denied:
            self.authroizedHandler?(false, .denied)
        case .notDetermined:
            self.authroizedHandler?(false, .notDetermined)
        case .restricted:
            self.authroizedHandler?(false, .restricted)
        }
    }
}


// MARK:- PhotoLibrary
extension IWPermissionManager where T: IWPPhotoLibrary {
    
    /// (获取当前授权类型).
    public var authorizationType: AuthorizationType { return .photoLibrary }
    
    /// (获取当前 PhotoLibrary 授权状态).
    public var authorizationStatus: AuthorizationStatus {
        return AuthorizationStatus.init(rawValue: PHPhotoLibrary.authorizationStatus().rawValue)!
    }
    
    /// (请求 PhotoLibrary 权限).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func request(_ handler: @escaping AuthorizedBlock) {
        self.authroizedHandler = handler
        
        let status = authorizationStatus
        switch status {
        case .none, .notDetermined:
            requestAuthorization()
            
        case .authorized:
            handler(true, .authorized)
            
        case .denied, .restricted:
            handler(false, status)
        }
    }
    
    private func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { (status) in
            let resStatus = AuthorizationStatus.init(rawValue: status.rawValue)!
            switch status {
            case .authorized:
                self.authroizedHandler?(true, resStatus)
            case .denied, .restricted:
                self.authroizedHandler?(false, resStatus)
            default: break
            }
        }
    }
    
}


// MARK:- Camera
extension IWPermissionManager where T: IWPCamera {
    
    /// (获取当前授权类型).
    public var authorizationType: AuthorizationType {
        return .camera
    }
    
    /// (获取当前 Camera 授权状态).
    public var authorizationStatus: AuthorizationStatus {
        if isCameraAvailable {
            return AuthorizationStatus.init(rawValue: AVCaptureDevice.authorizationStatus(for: .video).rawValue)!
        }
        iPrint("当前设备无相机.")
        return .none
    }
    
    /// (请求 相机 权限).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func request(_ handler: @escaping AuthorizedBlock) {
        
        // 判断有摄像头并且可用
        guard isCameraAvailable && (isFrontCameraAvailable || isRearCameraAvailable) else {
            iPrint("摄像头不可用.")
            handler(false, .none)
            return
        }
        
        let status = authorizationStatus
        switch status {
        case .authorized:
            handler(true, .authorized)
        case .denied, .restricted:
            handler(false, status)
        default: break
        }
        
        self.authroizedHandler = handler
        // 请求授权，预备搞事
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (authPassed) in
            self.authroizedHandler?(authPassed, authPassed ? .authorized : .denied)
        }
    }
    
    /// (判断是否有摄像头).
    public var isCameraAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    /// (前置摄像头是否可用).
    public var isFrontCameraAvailable: Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.front)
    }
    /// (后置摄像头是否可用).
    public var isRearCameraAvailable: Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.rear)
    }
    
}


// MARK:- Location
extension IWPermissionManager where T: IWPLocation {
    
    /// (获取当前授权类型).
    public var authorizationType: AuthorizationType {
        return .location
    }
    
    /// (获取当前 Location 授权状态).
    public var authorizationStatus: AuthorizationStatus {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        }
    }
    
    /// (请求 仅在使用时 授权).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func requestWhenInUse(_ handler: @escaping AuthorizedBlock) {
        if authorizationStatus == .authorized {
            handler(true, .authorized)
        } else if authorizationStatus != .notDetermined {
            handler(false, authorizationStatus)
        } else {
            self.authroizedHandler = handler
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// (请求 总是使用位置信息 授权).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func requestAlwaysUse(_ handler: @escaping AuthorizedBlock) {
        if authorizationStatus == .authorized {
            handler(true, .authorized)
        } else if authorizationStatus != .notDetermined {
            handler(false, authorizationStatus)
        } else {
            self.authroizedHandler = handler
            locationManager.requestAlwaysAuthorization()
        }
    }
}


// MARK:- Microphone
extension IWPermissionManager where T: IWPMicrophone {
    
    /// (获取当前授权类型).
    public var authorizationType: AuthorizationType {
        return .location
    }
    
    /// (获取当前 Location 授权状态).
    public var authorizationStatus: AuthorizationStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        return AuthorizationStatus.init(rawValue: status.rawValue)!
    }
    
    /// (请求 麦克风 权限).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func request(_ handler: @escaping AuthorizedBlock) {
        let status = authorizationStatus
        switch status {
        case .authorized:
            handler(true, .authorized)
        case .denied, .none, .restricted:
            handler(false, status)
        case .notDetermined:
            self.authroizedHandler = handler
            AVCaptureDevice.requestAccess(for: .audio) { (authPassed) in
                self.authroizedHandler?(authPassed, authPassed ? .authorized : .denied)
            }
        }
    }
    
}


// MARK:- Contacts
extension IWPermissionManager where T: IWPContacts {
    
    /// (获取当前授权类型).
    public var authorizationType: AuthorizationType {
        return .contacts
    }
    
    /// (获取当前 Location 授权状态).
    public var authorizationStatus: AuthorizationStatus {
        if #available(iOS 9.0, *) {
            let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            return AuthorizationStatus.init(rawValue: status.rawValue)!
        } else {
            return AuthorizationStatus.init(rawValue: ABAddressBookGetAuthorizationStatus().rawValue)!
        }
    }
    
    /// (请求 l联系人 权限).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func request(_ handler: @escaping AuthorizedBlock) {
        let status = authorizationStatus
        switch status {
        case .authorized:
            handler(true, .authorized)
        case .denied, .restricted, .none:
            handler(false, status)
        case .notDetermined:
            self.authroizedHandler = handler
            if #available(iOS 9.0, *) {
                requestiOS9After()
            } else {
                reqeustiOS9Before()
            }
        }
    }
    
    private func reqeustiOS9Before() {
        if let addressBook = ABAddressBookCreateWithOptions(nil, nil) {
            ABAddressBookRequestAccessWithCompletion(addressBook as ABAddressBook) { (through, error) in
                self.authroizedHandler?(through, through ? .authorized : .denied)
            }
            return
        }
        self.authroizedHandler?(false, .none)
    }
    @available(iOS 9.0, *)
    private func requestiOS9After() {
        let contactStore = CNContactStore.init()
        contactStore.requestAccess(for: CNEntityType.contacts) { (through, error) in
            self.authroizedHandler?(through, through ? .authorized : .denied)
            if !through { iPrint(error: error) }
        }
    }
}

// MARK:- Calendar
extension IWPermissionManager where T: IWPCalendar {
    
    /// (获取当前授权类型).
    public var authorizationType: AuthorizationType {
        return .calendar
    }
    
    /// (获取当前 Calendar 授权状态).
    public var authorizationStatus: AuthorizationStatus {
        return AuthorizationStatus.init(rawValue: EKEventStore.authorizationStatus(for: .event).rawValue)!
    }
    
    /// (请求 日历 权限).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func request(_ handler: @escaping AuthorizedBlock) {
        let status = authorizationStatus
        switch status {
        case .authorized:
            handler(true, status)
        case .denied, .restricted, .none :
            handler(false, status)
        case .notDetermined:
            self.authroizedHandler = handler
            let store = EKEventStore.init()
            store.requestAccess(to: .event) { (through, error) in
                self.authroizedHandler?(through, through ? .authorized : .denied)
                if !through { iPrint(error: error) }
            }
        }
    }
    
}

// MARK:- Reminder
extension IWPermissionManager where T: IWPReminder {
    
    /// (获取当前授权类型).
    public var authorizationType: AuthorizationType {
        return .reminder
    }
    
    /// (获取当前 Calendar 授权状态).
    public var authorizationStatus: AuthorizationStatus {
        return AuthorizationStatus.init(rawValue: EKEventStore.authorizationStatus(for: .reminder).rawValue)!
    }
    
    /// (请求 备忘录 权限).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func request(_ handler: @escaping AuthorizedBlock) {
        let status = authorizationStatus
        switch status {
        case .authorized:
            handler(true, status)
        case .denied, .restricted, .none :
            handler(false, status)
        case .notDetermined:
            self.authroizedHandler = handler
            let store = EKEventStore.init()
            store.requestAccess(to: .reminder) { (through, error) in
                self.authroizedHandler?(through, through ? .authorized : .denied)
                if !through { iPrint(error: error) }
            }
        }
    }
    
}


// MARK:- Apple music
@available(iOS 9.3, *)
extension IWPermissionManager where T: IWPAppleMusic {
    
    /// (获取当前授权类型).
    public var authorizationType: AuthorizationType {
        return .appleMusic
    }
    /// (获取当前 Calendar 授权状态).
    public var authorizationStatus: AuthorizationStatus {
        var raw = MPMediaLibrary.authorizationStatus().rawValue
        if raw == 1 {
            raw = 2
        } else if raw == 2 {
            raw = 1
        }
        return AuthorizationStatus.init(rawValue: raw)!
    }
    
    /// (请求 Apple Music 权限).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func request(_ handler: @escaping AuthorizedBlock) {
        let status = authorizationStatus
        switch status {
        case .authorized:
            handler(true, status)
        case .denied, .restricted, .none :
            handler(false, status)
        case .notDetermined:
            self.authroizedHandler = handler
            MPMediaLibrary.requestAuthorization { (authStatus) in
                self.authroizedHandler?(authStatus == .authorized, AuthorizationStatus.init(rawValue: authStatus.rawValue)!)
            }
        }
    }
    
}

// MARK:- 健康
extension IWPermissionManager where T: IWPHealth {
    
    /// (获取当前授权类型).
    public var authorizationType: AuthorizationType {
        return .health
    }
    
    private var readAndWriteTypes: Set<HKSampleType> {
        guard let setpType = HKObjectType.quantityType(forIdentifier: .stepCount) else { fatalError("Quantity type: .setcount failed.") }
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            fatalError("Quantity type: .distanceWalkingRunning failed.")
        }
        return Set(arrayLiteral: setpType, distanceType)
    }
    
    /// (获取当前 Health .setupCount 授权状态).
    public var authorizationStatus: AuthorizationStatus {
        guard HKHealthStore.isHealthDataAvailable() else {
            iPrint("该设备不支持 Health。")
            return .none
        }
        
        guard let setupCountType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            iPrint("无法创建 .setupCount。")
            return .none
        }
        
        let status = HKHealthStore.init().authorizationStatus(for: setupCountType)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .sharingDenied:
            return .denied
        case .sharingAuthorized:
            return .authorized
        }
    }
    
    /// (请求 Health 权限).
    ///
    /// *需要在 Info.plist 中加入相关配置
    /// - Parameter handler: 授权结果回调
    public func request(_ handler: @escaping AuthorizedBlock) {
        let status = authorizationStatus
        switch status {
        case .authorized:
            handler(true, status)
        case .denied, .restricted, .none :
            handler(false, status)
        case .notDetermined:
            self.authroizedHandler = handler
            HKHealthStore.init().requestAuthorization(toShare: readAndWriteTypes, read: readAndWriteTypes) { (through, error) in
                self.authroizedHandler?(through, through ? .authorized : .denied)
                if !through { iPrint(error: error) }
            }
        }
    }
}
