//  Created by iWw on 2018/3/13.
//  Copyright © 2018年 iWe. All rights reserved.
//

/**
 使用之前先执行以下操作:
 1. xcodeproject -> TARGETS -> Capabilities -> 打开 Keychain Sharing. 1⃣️Keychan Groups: 值
 2. 打开1后左侧栏会自动生成 xxxx.entitlements, 2⃣️Keychain Access Groups: $(AppIdentifierPrefix)1⃣️值
 3. 查看程序设置的3⃣️Bundle Identifier.
 若 1⃣️2⃣️3⃣️的值一致, 则修改当前.m文件中的 kKeyUUID, 格式为: Bunlde Identifier.UUID 例如: com.iwe.dcsj.UUID
 OK 到此完毕, 可以正常使用 iwe_get 获取唯一的UUID, 重启设备、重装应用都不会变
 */

#if os(iOS)
    import UIKit
#endif

public class IWUUID: NSObject {
    
    private static let UUIDKey: String = "cc.iwe.UUID"
    
    /// (获取 keyChain 中保存的 UUID, 没有的话需要先配置 UUIDKey, 首次使用会自动存储进去).
    static var get: String? {
        guard var uuidOfStr = IWKeyChainManager.loadString(service: self.UUIDKey) else {
            return nil
        }
        if uuidOfStr == "" {
            let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
            if let str = CFBridgingRetain(CFUUIDCreateString(kCFAllocatorDefault, uuidRef)) as? String {
                uuidOfStr = str
                IWKeyChainManager.save(service: UUIDKey, value: uuidOfStr as Any)
            }
        }
        return uuidOfStr
    }
    
}
