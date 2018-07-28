//
//  LocalNotification.swift
//  Days
//
//  Created by Myron on 2018/6/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotification: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - Values
    
    static let center = UNUserNotificationCenter.current()
    static var allow: Bool = false
    static let local: LocalNotification = LocalNotification()
    
    // MARK: - Actions
    
    /** 注册通知，检查权限 */
    class func authorization() {
        center.requestAuthorization(
            options: [.badge, .sound, .alert],
            completionHandler: { (granted, error) in // 允许? 错误
        })
        center.getNotificationSettings(completionHandler: { (settings) in
            self.allow = (settings.authorizationStatus == .authorized)
        })
        center.delegate = LocalNotification.local
    }
    
    /** 倒计时界面专用 */
    class func stopwatch(unit: String? = nil, length: Int = 0, space: Int = 0) {
        if let unit = unit {
            LocalNotification.Category.timer()
            
            let content = UNMutableNotificationContent()
            content.title = "\(unit)"
            content.body  = "你已经坚持 \(Format.time_text(second: length)) 了，需要休息一下吗？"
            content.categoryIdentifier = Keys.Category.timer
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: Double(space),
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: Keys.Request.stopwatch,
                content: content,
                trigger: trigger
            )
            
            center.add(request, withCompletionHandler: nil)
        } else {
            center.removePendingNotificationRequests(
                withIdentifiers: [Keys.Request.stopwatch]
            )
        }
    }
    
    // MARK: - Actions
    
    class Actions {
        static let save: UNNotificationAction = {
            let action = UNNotificationAction(
                identifier: Keys.Action.save,
                title: "保存",
                options: UNNotificationActionOptions(rawValue: 0)
            )
            return action
        }()
        static let still: UNNotificationAction = {
            let action = UNNotificationAction(
                identifier: Keys.Action.still,
                title: "继续",
                options: UNNotificationActionOptions(rawValue: 0)
            )
            return action
        }()
        static let cancel: UNNotificationAction = {
            let action = UNNotificationAction(
                identifier: Keys.Action.cancel,
                title: "取消",
                options: UNNotificationActionOptions.destructive
            )
            return action
        }()
        static let input: UNTextInputNotificationAction = {
            let action = UNTextInputNotificationAction(
                identifier: Keys.Action.input,
                title: "输入备注",
                options: UNNotificationActionOptions(rawValue: 0),
                textInputButtonTitle: "保存",
                textInputPlaceholder: ""
            )
            return action
        }()
        static let done: UNNotificationAction = {
            let action = UNNotificationAction(
                identifier: Keys.Action.done,
                title: "完成",
                options: UNNotificationActionOptions(rawValue: 0)
            )
            return action
        }()
    }
    
    // MARK: - Category
    
    class Category {
        class func timer() {
            let category = UNNotificationCategory(
                identifier: Keys.Category.timer,
                actions: [
                    LocalNotification.Actions.save,
                    LocalNotification.Actions.still,
                    LocalNotification.Actions.input,
                    LocalNotification.Actions.cancel
                ],
                intentIdentifiers: [],
                hiddenPreviewsBodyPlaceholder: "",
                options: .customDismissAction
            )
            LocalNotification.center.setNotificationCategories([category])
        }
        class func hint() {
            let category = UNNotificationCategory(
                identifier: Keys.Category.hint,
                actions: [
                    LocalNotification.Actions.done,
                    LocalNotification.Actions.cancel
                ],
                intentIdentifiers: [],
                hiddenPreviewsBodyPlaceholder: "",
                options: .customDismissAction
            )
            LocalNotification.center.setNotificationCategories([category])
        }
    }
    
    // MARK: - Keys
    
    class Keys {
        class Category {
            static let timer = "LocalNotification_Key_Category_timer"
            static let hint = "LocalNotification_Key_Category_hint"
        }
        class Action {
            static let save = "LocalNotification_Key_Action_save"
            static let still = "LocalNotification_Key_Action_still"
            static let cancel = "LocalNotification_Key_Action_cancel"
            static let input = "LocalNotification_Key_Action_input"
            static let done = "LocalNotification_Key_Action_done"
        }
        class Request {
            static let stopwatch = "LocalNotification_Key_Request_stopwatch"
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // 接收到通知时应用反馈时的处理
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.notification.request.identifier {
        case Keys.Request.stopwatch: // MARK: Keys.Request.stopwatch
            switch response.actionIdentifier {
            case Keys.Action.save:
                NotificationCenter.default.post(
                    name: Keys.Request.stopwatch.notification,
                    object: self,
                    userInfo: ["Key": Keys.Action.save]
                )
            case Keys.Action.still:
                if let obj = TimerController.Unit.obj() {
                    obj.length += obj.space
                    obj.save()
                    LocalNotification.stopwatch(
                        unit: response.notification.request.content.title,
                        length: obj.length,
                        space: obj.space
                    )
                }
            case Keys.Action.input:
                if let obj = TimerController.Unit.obj() {
                    let input = response as? UNTextInputNotificationResponse
                    obj.text = (input?.userText ?? "")
                    obj.save()
                }
                NotificationCenter.default.post(
                    name: Keys.Request.stopwatch.notification,
                    object: self,
                    userInfo: ["Key": Keys.Action.save]
                )
            case Keys.Action.cancel:
                NotificationCenter.default.post(
                    name: Keys.Request.stopwatch.notification,
                    object: self,
                    userInfo: ["Key": Keys.Action.cancel]
                )
            default: break
            }
        default: break
        }
        completionHandler()
    }
    
    // 接收到通知时应用在前台的处理
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        switch notification.request.identifier {
        case Keys.Request.stopwatch: break
        default: break
        }
        completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
    
}



//import UserNotifications
//
//class ViewController: UIViewController, UNUserNotificationCenterDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//
//        // 1. 事件
//        let done_action = UNNotificationAction(
//            identifier: "Done_Action",
//            title: "完成",
//            options: UNNotificationActionOptions.init(rawValue: 0)
//        )
//        let continue_action = UNNotificationAction(
//            identifier: "Continue_Action",
//            title: "继续",
//            options: UNNotificationActionOptions.init(rawValue: 0)
//        )
//        let text = UNTextInputNotificationAction(
//            identifier: "Input",
//            title: "输入",
//            options: UNNotificationActionOptions.init(rawValue: 0)
//        )
//
//        // 2. 生成属性
//        let category = UNNotificationCategory(
//            identifier: "Return_Notification",
//            actions: [done_action, continue_action, text],
//            intentIdentifiers: [],
//            hiddenPreviewsBodyPlaceholder: "",
//            options: .customDismissAction
//        )
//        // 3. 注册属性
//        center.setNotificationCategories([category])
//
//        // 4. 推送通知
//        let alert_content = UNMutableNotificationContent()
//        alert_content.title = "测试通知标题"
//        alert_content.body  = "测试通知的内容，可以长一点。"
//        alert_content.userInfo = ["Date": "OK"] // 传递数据
//        alert_content.categoryIdentifier = "Return_Notification"
//
//        // 多久之后进行推送，如果要重复，至少要 60 秒之后
//        let trigger = UNTimeIntervalNotificationTrigger(
//            timeInterval: 10,
//            repeats: false
//        )
//
//        let request = UNNotificationRequest(
//            identifier: "通知请求",
//            content: alert_content,
//            trigger: trigger
//        )
//
//        center.add(request, withCompletionHandler: { (error) in
//            // 成功添加推送
//            print("add request success \(String(describing: error))")
//        })
//
//        //        let center = UNUserNotificationCenter.current()
//        //        // 1. 获取权限
//        //        /**
//        //         .badge // 小红点
//        //         .sound // 声音
//        //         .alert // 警告
//        //         .carPlay // 车上播放
//        //         */
//        //        center.requestAuthorization(
//        //            options: [.badge, .sound, .alert],
//        //            completionHandler: { (granted, error) in // 允许? 错误
//        //                if granted {
//        //                    print("允许")
//        //                } else {
//        //                    print("拒绝")
//        //                }
//        //        })
//        //
//        //        // 2. 检查权限
//        //        center.getNotificationSettings(completionHandler: { (settings) in
//        //            // 如果不允许，则不应该进行操作
//        //            guard settings.authorizationStatus == .authorized else {return}
//        //
//        //            if settings.badgeSetting == .enabled { print("badgeSetting") }
//        //            if settings.soundSetting == .enabled { print("soundSetting") }
//        //            if settings.alertSetting == .enabled { print("alertSetting") }
//        //        })
//        //
//        //        // 3. 推送通知
//        //        let alert_content = UNMutableNotificationContent()
//        //        alert_content.title = "测试通知标题"
//        //        alert_content.body  = "测试通知的内容，可以长一点。"
//        //        alert_content.sound = UNNotificationSound.default() // 声音
//        //
//        //        // 多久之后进行推送，如果要重复，至少要 60 秒之后
//        //        let trigger = UNTimeIntervalNotificationTrigger(
//        //            timeInterval: 60,
//        //            repeats: true
//        //        )
//        //
//        //        let request = UNNotificationRequest(
//        //            identifier: "通知请求",
//        //            content: alert_content,
//        //            trigger: trigger
//        //        )
//        //
//        //
//        //        center.add(request, withCompletionHandler: { (error) in
//        //            // 成功添加推送
//        //            print("add request success \(String(describing: error))")
//        //        })
//        //
//        //        // 移除通知
//        //        center.removeAllPendingNotificationRequests()
//        //        center.removePendingNotificationRequests(withIdentifiers: ["通知请求"])
//    }
//
//
//    // MARK: - UNUserNotificationCenterDelegate
//
//    // 接收到通知时应用反馈时的处理
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let info = response.notification.request.content.userInfo
//        let date = info["Date"] as! String
//        switch response.actionIdentifier {
//        case "Continue_Action":
//            print("Continue_Action return \(date)")
//        case "Input":
//            print("Input return \(date)")
//            if let input = response as? UNTextInputNotificationResponse {
//                print(input.userText)
//            }
//        case "Done_Action":
//            print("Done_Action return \(date)")
//        default: break
//        }
//        completionHandler()
//    }
//
//    // 接收到通知时应用在前台的处理
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        /** 处理通知 */
//        print("userNotificationCenter \(notification)")
//        /** 处理完后调用 */
//        // UNNotificationPresentationOptions(rawValue: 0) 表示不作处理
//        completionHandler(.alert)
//    }
//
//
//}
