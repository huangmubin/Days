//
//  LocalNotification.swift
//  Days
//
//  Created by Myron on 2018/6/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotification {
    
    // MARK: - Values
    
    static let center = UNUserNotificationCenter.current()
    static var allow: Bool = false
    
    // MARK: - Actions
    
    /** 注册通知，检查权限 */
    class func authorization() {
        center.requestAuthorization(
            options: [.badge, .sound, .alert],
            completionHandler: { (granted, error) in // 允许? 错误
        })
        center.getNotificationSettings(completionHandler: { (settings) in
            self.allow = (settings.authorizationStatus == .authorized)
            if self.allow {
                LocalNotification.Category.timer()
                LocalNotification.Category.hint()
            }
        })
    }
    
    func normal() {
        
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
                identifier: "Return_Notification",
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
                identifier: "Return_Notification",
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
    }
}
