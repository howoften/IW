//
//  PermissionsViewController.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/4/11.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

class PermissionsViewController: IWSubVC {
    
    let photoLibraryManager = IWPermissionManager<IWPPhotoLibrary>.init()
    @IBOutlet weak var photoLibraryBtn: UIButton!
    @IBOutlet weak var photoLibraryStatus: UILabel!
    
    let cameraManager = IWPermissionManager<IWPCamera>.init()
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var cameraStatus: UILabel!
    
    let locationManager = IWPermissionManager<IWPLocation>.init()
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var locationStatus: UILabel!
    
    let microphoneManager = IWPermissionManager<IWPMicrophone>.init()
    @IBOutlet weak var microphoneBtn: UIButton!
    @IBOutlet weak var microphoneStatus: UILabel!
    
    let contactsManager = IWPermissionManager<IWPContacts>.init()
    @IBOutlet weak var contactsBtn: UIButton!
    @IBOutlet weak var contactsStatus: UILabel!
    
    let calendarManager = IWPermissionManager<IWPCalendar>.init()
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var calendarStatus: UILabel!
    
    let reminderManager = IWPermissionManager<IWPReminder>.init()
    @IBOutlet weak var reminderBtn: UIButton!
    @IBOutlet weak var reminderStatus: UILabel!
    
    let musicManager = IWPermissionManager<IWPAppleMusic>.init()
    @IBOutlet weak var musicBtn: UIButton!
    @IBOutlet weak var musicStatus: UILabel!
    
    let healthManager = IWPermissionManager<IWPHealth>.init()
    @IBOutlet weak var healthBtn: UIButton!
    @IBOutlet weak var healthStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configureUserInterface() {
        navigationItemTitle = "权限请求/管理"
        useLayoutGuide.enable()
        
        setupRightBarButtomItem("App设置", target: self, action: #selector(openAppSettingsInSettings))
        
        refreshAuthoritionStatus()
    }
    
    func refreshAuthoritionStatus() -> Void {
        let photoLibraryAuthStatus = photoLibraryManager.authorizationStatus
        let cameraAuthStatus = cameraManager.authorizationStatus
        let locationAuthStatus = locationManager.authorizationStatus
        let microphoneAuthStatus = microphoneManager.authorizationStatus
        let contactsAuthStatus = contactsManager.authorizationStatus
        let calendarAuthStatus = calendarManager.authorizationStatus
        let reminderAuthStatus = reminderManager.authorizationStatus
        let healthAuthStatus = healthManager.authorizationStatus
        
        photoLibraryStatus.text = "相册授权状态：" + photoLibraryAuthStatus.description
        cameraStatus.text = "相机授权状态：" + cameraAuthStatus.description
        locationStatus.text = "位置授权状态：" + locationAuthStatus.description
        microphoneStatus.text = "麦克风授权状态：" + microphoneAuthStatus.description
        contactsStatus.text = "通讯录授权状态：" + contactsAuthStatus.description
        calendarStatus.text = "日历授权状态：" + calendarAuthStatus.description
        reminderStatus.text = "备忘录授权状态：" + reminderAuthStatus.description
        healthStatus.text = "健康授权状态：" + healthAuthStatus.description
        
        photoLibraryBtn.iwe.isEnable(false).where(photoLibraryAuthStatus.is(.authorized))
        cameraBtn.iwe.isEnable(false).where(cameraAuthStatus.is(.authorized))
        locationBtn.iwe.isEnable(false).where(locationAuthStatus.is(.authorized))
        microphoneBtn.iwe.isEnable(false).where(microphoneAuthStatus.is(.authorized))
        contactsBtn.iwe.isEnable(false).where(contactsAuthStatus.is(.authorized))
        calendarBtn.iwe.isEnable(false).where(calendarAuthStatus.is(.authorized))
        reminderBtn.iwe.isEnable(false).where(reminderAuthStatus.is(.authorized))
        healthBtn.iwe.isEnable(false).where(healthAuthStatus.is(.authorized))
        
        if #available(iOS 9.3, *) {
            let musicAuthStatus = musicManager.authorizationStatus
            musicStatus.text = "Apple Music 授权状态：" + musicAuthStatus.description
            musicBtn.iwe.isEnable(false).where(musicAuthStatus.is(.authorized))
        } else {
            musicStatus.text = "Apple Music 授权状态：系统版本在 9.3 及以上才可使用"
            musicBtn.isEnabled = false
        }
    }
    
    @objc func openAppSettingsInSettings() {
        let urlPath = UIApplicationOpenSettingsURLString
        if let url = URL(string: urlPath) {
            UIApplication.shared.openURL(url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func requestPhotoLibrary(_ sender: Any) {
        photoLibraryManager.request { (through, status) in
            iw.queue.main {
                self.photoLibraryStatus.text = "相册授权状态：" + status.description
            }
        }
    }
    
    @IBAction func requestCamera(_ sender: Any) {
        cameraManager.request { (through, status) in
            iw.queue.main {
                self.cameraStatus.text = "相机授权状态：" + status.description
            }
        }
    }
    
    @IBAction func requestLocation(_ sender: Any) {
        locationManager.requestWhenInUse { (through, status) in
            iw.queue.main {
                self.locationStatus.text = "位置授权状态：" + status.description
            }
        }
    }
    
    @IBAction func requestMicrophone(_ sender: Any) {
        microphoneManager.request { (through, status) in
            iw.queue.main {
                self.microphoneStatus.text = "麦克风授权状态：" + status.description
            }
        }
    }
    
    @IBAction func requestContats(_ sender: Any) {
        contactsManager.request { (through, status) in
            iw.queue.main {
                self.contactsStatus.text = "通讯录授权状态：" + status.description
            }
        }
    }
    
    @IBAction func requestCalendar(_ sender: Any) {
        calendarManager.request { (through, status) in
            iw.queue.main {
                self.calendarStatus.text = "日历授权状态：" + status.description
            }
        }
    }
    
    @IBAction func requestReminder(_ sender: Any) {
        reminderManager.request { (through, status) in
            iw.queue.main {
                self.reminderStatus.text = "备忘录授权状态：" + status.description
            }
        }
    }
    
    @IBAction func requestAppleMusic(_ sender: Any) {
        if #available(iOS 9.3, *) {
            musicManager.request { (through, status) in
                iw.queue.main {
                    self.musicStatus.text = "Apple Music 授权状态：" + status.description
                }
            }
        }
    }
    
    @IBAction func requestHealth(_ sender: Any) {
        healthManager.request { (through, status) in
            iw.queue.main {
                self.healthStatus.text = "健康授权状态：" + status.description
            }
        }
    }
    
    override func navigationPopOnBackHandler() {
        IWNaver.shared.nextPopWithoutAnimation = true
        iw.naver.url("../CollectionViewLayoutViewController")
    }
}
