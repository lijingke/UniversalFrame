//
//  CommonUtil.swift
//  shopping
//
//  Created by 李京珂 on 2021/7/20.
//

import AVFoundation
import CoreImage
import Foundation
import Kingfisher
import MBProgressHUD
import Moya
import SwiftyJSON
import UserNotifications

class CommonUtil: NSObject {
    
    /// 正则，找出指定字符串
    static func regexGetSub(pattern: String, str: String)->[String] {
        var subStr: [String] = []
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: str, options: [], range: NSRange(str.startIndex..., in: str))
        for match in matches {
            let matchStr = (str as NSString).substring(with: match.range)
            subStr.append(matchStr)
        }
        return subStr
    }
    
    /// 去重 except:排除
    static func repetArr(_ arr: [String], _ except: [String])->[String] {
        var result: [String] = []
        for str in arr {
            var find = false
            var isExcept = false
            for exceStr in except {
                if str == exceStr {
                    isExcept = true
                    continue
                }
            }
            for string in result {
                if string == str {
                    find = true
                    continue
                }
            }
            if !find, !isExcept {
                result.append(str)
            }
        }
        
        return result
    }
    
    /// 获取包名
    static func getiIdentifier()->String {
        let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
        return identifier
    }
    
    /// 转换2位数字符串
    static func getDoubleStr(_ value: Double)->String {
        let str = String(format: "%.2lf", value)
        return str
    }

    /// 跳转登录
    static func enterLoginPage() {
        let app = UIApplication.shared.delegate as? AppDelegate
        if app != nil {
//            app!.enterLoginPage()
        }
    }
    
    /// 是否需要完善资料
    static func isNeedCompleteInfo(_ userInfo: [String: Any])->Bool {
        let name = userInfo["name"] as? String ?? ""
        let nickName = userInfo["nickName"] as? String ?? ""
        return (name.count == 0) && (nickName.count == 0)
    }
    
    /// 去掉+86
    static func getPhonNo86(phone: String)->String {
        if phone.hasPrefix("+86-") {
            return phone.getSubString(startIndex: 4, endIndex: phone.count - 1)
        }
        return phone
    }
    
    /// 获取隐藏中间号码段的电话号
    static func getPhoneHide(phone: String) ->String {
        if phone.count < 11 {
            return phone
        }
        var str = phone.getSubString(startIndex: 0, endIndex: 2)
        str.append("****")
        str.append(phone.getSubString(startIndex: 7, endIndex: 10))
        return str
    }

    /// 增加通知监听
    static func register(_ obver: Any, _ sel: Selector, _ name: String) {
        NotificationCenter.default.addObserver(obver, selector: sel, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    /// 发送通知
    static func sendNotify(_ name: String, _ obj: Any?) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: obj)
    }
    
    /// 打开URL
    static func open(url: String) {
//        if url.count == 0 { UIAlertController.alert("无法打开"); return }
        let urlS = URL(string: url)!
        UIApplication.shared.open(urlS, options: [:]) { _ in
        }
    }
    
    // 屏幕宽度
    static var scW: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // 屏幕高度
    static var scH: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 拨打电话
    static func telPhone(num: String) {
        let urlString = "tel://\(num)"
        if let url = URL(string: urlString) {
            // 根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                              _ in
                                          })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func isNull(string: Any?)->Bool {
        if string == nil {
            return true
        }
        let bo = string as? String ?? ""
        if bo.count == 0 {
            return true
        }
        return false
    }

    /// 根据阿拉伯数字，返回对应星期
    static func getWeak(weak: Int) ->String {
        switch weak {
        case 1:
            return "一"
        case 2:
            return "二"
        case 3:
            return "三"
        case 4:
            return "四"
        case 5:
            return "五"
        case 6:
            return "六"
        case 7:
            return "天"
        default:
            return ""
        }
    }

    /// 是否可以使用通知
    static func isEnabelNotifi()->Bool {
        let seting = UIApplication.shared.currentUserNotificationSettings
        if Int(seting?.types.rawValue ?? 0) == 0 {
            return false
        }
        return true
    }
    
    /// 发送本地推送
    static func postLocalNotification(title: String?, body: String, userInfo: [AnyHashable: Any]) {
        LogUtil.log("---发送自定义通知22---")
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = title ?? ""
            content.subtitle = ""
            content.body = body
            content.userInfo = userInfo
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(1), repeats: false)
            let request = UNNotificationRequest(identifier: "CustomNotify", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        } else {
            let notification = UILocalNotification()
            let fireDate = Date(timeIntervalSinceNow: TimeInterval(1))
            notification.fireDate = fireDate
            notification.timeZone = NSTimeZone.default
            notification.alertBody = body
            notification.soundName = UILocalNotificationDefaultSoundName
            if UIApplication.shared.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
                let type = UInt8(UIUserNotificationType.alert.rawValue) | UInt8(UIUserNotificationType.badge.rawValue) | UInt8(UIUserNotificationType.sound.rawValue)
                let setting = UIUserNotificationSettings(types: UIUserNotificationType(rawValue: UInt(type)), categories: nil)
                UIApplication.shared.registerUserNotificationSettings(setting)
            }
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }

    // 发起本地通知
    static func postLocalNotification(title: String?, body: String) {
        LogUtil.log("---发送自定义通知---")
        postLocalNotification(title: title, body: body, userInfo: [:])
    }
    
    // 打开相册
    static func openPhoto(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, from: UIViewController, allowEdit: Bool, sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = delegate
            imagePicker.allowsEditing = allowEdit
            from.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // 开启或关闭闪光灯
    static func openLight(isOpen: Bool) {
        let device = AVCaptureDevice.default(for: .video)
        if (device?.hasTorch)! {
            let torchMode = isOpen ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
            let flashMode = isOpen ? AVCaptureDevice.FlashMode.on : AVCaptureDevice.FlashMode.off
            if device?.torchMode != torchMode ||
                device?.flashMode != flashMode
            {
                do {
                    try device?.lockForConfiguration()
                    device?.torchMode = torchMode
                    device?.flashMode = flashMode
                    device?.unlockForConfiguration()
                } catch let error as NSError {
                    LogUtil.log(error.localizedDescription)
                }
            }
        }
    }
    
    // 开启系统震动
    static func openShake(isShake: Bool, sound: Bool) {
        if isShake {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        if sound {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(NSURL(fileURLWithPath: Bundle.main.path(forResource: "scan_res.bundle/ring", ofType: "wav")!), &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
    
    // 验证手机号
    static func validatePhone(phone: String)->Bool {
        let regex = "^[1]\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: phone)
    }
    
    // 验证邮箱
    static func validateEmail(email: String)->Bool {
        let regex = "[\\w]+(\\.[\\w]+)*@[\\w]+(\\.[\\w]+)+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
       
    static func toInt(_ obj: Any?)->Int {
        let value = "\(obj ?? "0")".toInt()
        return value
    }
        
    static func getStringByRangeIntValue(Str: NSString, location: Int, length: Int)->Int {
        let a = Str.substring(with: NSRange(location: location, length: length))
        let intValue = (a as NSString).integerValue
        return intValue
    }
    
    /// 显示等待自定义位置框
    static func showWaitHUD(view: UIView, offset: CGPoint) {
        let waitHUD = MBProgressHUD.showAdded(to: view, animated: true)
        waitHUD.mode = .indeterminate
        waitHUD.removeFromSuperViewOnHide = true
        waitHUD.bezelView.color = UIColor.black.withAlphaComponent(0.8)
        waitHUD.contentColor = .white
        waitHUD.offset = offset
        waitHUD.bezelView.style = .solidColor
        waitHUD.backgroundView.style = .solidColor
        waitHUD.animationType = .zoom
        waitHUD.show(animated: true)
    }
    
    // 显示等待view
    static func showWaitHUD(view: UIView) {
        let waitHUD = MBProgressHUD.showAdded(to: view, animated: true)
        waitHUD.mode = .indeterminate
        waitHUD.removeFromSuperViewOnHide = true
        waitHUD.bezelView.color = UIColor.black.withAlphaComponent(0.8)
        waitHUD.contentColor = .white
        waitHUD.bezelView.style = .solidColor
        waitHUD.backgroundView.style = .solidColor
        waitHUD.animationType = .zoom
        waitHUD.show(animated: true)
    }
  
    // 隐藏等待view
    static func hiddenWaitHUD(view: UIView) {
        let hud = MBProgressHUD(view: view)
        if hud.mode != .text {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    // 显示label view
    static func showTextHUD(view: UIView, text: String) {
        if text.count == 0 { return }
        let textHUD = MBProgressHUD.showAdded(to: view, animated: true)
        textHUD.mode = .text
        textHUD.removeFromSuperViewOnHide = true
        textHUD.detailsLabel.text = text
        textHUD.detailsLabel.font = UIFont.systemFont(ofSize: 16)
        textHUD.bezelView.color = UIColor.black.withAlphaComponent(0.8)
        textHUD.contentColor = .white
        textHUD.bezelView.style = .solidColor
        textHUD.backgroundView.style = .solidColor
        textHUD.animationType = .zoom
        textHUD.hide(animated: true, afterDelay: 1.5)
    }
    
    // 打开系统设置
    static func openSetingPage() {
        let url = URL(string: UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: {
                _ in
            })
        }
    }
}
