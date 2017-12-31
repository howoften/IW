import Foundation
import CCommonCrypto

public extension String {
  
  public var md5: String {
    
    let length = Int(CC_MD5_DIGEST_LENGTH)
    
    guard let data = data(using: .utf8) else {
      return self
    }
    
    let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
      var hash = [UInt8](repeating: 0, count: length)
      CC_MD5(bytes, CC_LONG(data.count), &hash)
      return hash
    }
    
    return (0..<length)
      .map { String(format: hashFormat, hash[$0]) }
      .joined()
  }
  
  
  /// hashFormat - %02x
  private var hashFormat: String {
    return  "%02x"
  }
  
}
