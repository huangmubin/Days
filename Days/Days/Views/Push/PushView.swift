//
//  PushView.swift
//  Days
//
//  Created by 黄穆斌 on 2018/5/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

/** 初始化后，必须调用 push() */
class PushView: View {
    
    // MARK: - View Deploy
    
    //deinit {
    //    print("PushView is deinit")
    //}
    
    override func view_deploy() {
        //print("PushView is view deploy.")
        
        key_window.backgroundColor = Color.white.withAlphaComponent(0.5)
        key_window.windowLevel = UIWindowLevelStatusBar
        key_window.alpha = 1
        key_window.addSubview(self)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboard_will_change_frame(_:)),
            name: .UIKeyboardWillChangeFrame,
            object: nil
        )
    }
    
    // MARK: - Interface
    
    /** 弹出窗口 */
    func push() {
        key_window.makeKeyAndVisible()
    }
    
    /** Override: Call when keyboard open */
    func keyboard_open(rect: CGRect) { }
    
    /** Override: Call when keyboard close */
    func keyboard_close(rect: CGRect) { }
    
    // MARK: - Data
    
    /** 识别 id */
    var id: String = ""
    
    // MARK: - Window
    
    /** 背景视窗 */
    var key_window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    
    // MARK: - Keyboard Observer
    
    @objc func keyboard_will_change_frame(_ notification: Notification) {
        if let info = notification.userInfo {
            if let rect = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                self.keyboard_will_change_frame(keyboard: rect.cgRectValue)
            }
        }
    }
    
    /** Temp value */
    var keyboard_minY: CGFloat = 0
    /** keyboard will change to the new rect */
    func keyboard_will_change_frame(keyboard rect: CGRect) {
        keyboard_minY = rect.minY
        if rect.minY < UIScreen.main.bounds.height {
            keyboard_open(rect: rect)
        } else {
            keyboard_close(rect: rect)
        }
    }
    
}
