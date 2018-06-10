//
//  KeyboardTime.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class KeyboardTime: Keyboard {
    
    
    // MARK: - View Deploy
    
    override func view_deploy() {
        super.view_deploy()
        container.addSubview(hour)
        container.addSubview(minute)
        container.addSubview(split_label)
        
        hour.delegate        = self
        minute.delegate      = self
        
        text.isHidden = true
    }
    
    // MARK: - Interface
    
    /**  */
    override var value: Any {
        if is_avaible() {
            return Int(hour.text)! * 3600 + Int(minute.text)! * 60
        }
        return 0
    }
    
    /** 弹出窗口 */
    override func push() {
        key_window.makeKeyAndVisible()
        minute.becomeFirstResponder()
    }
    
    /** Update the date */
    func update(date: Date) {
        hour.text = date.hour.description
        minute.text = date.minute.description
    }
    
    /***/
    func is_avaible() -> Bool {
        if hour.text.isEmpty || minute.text.isEmpty {
            return false
        }
        guard let h = Int(hour.text), let m = Int(minute.text) else {
            return false
        }
        if m < 0 || m > 59 {
            return false
        }
        if h < 0 || h > 23 {
            return false
        }
        return true
    }
    
    // MARK: - Texts
    
    /**  */
    let hour: UITextView = {
        let text             = UITextView()
        text.font            = Font.text.m
        text.text            = format(Date().hour)
        text.textColor       = Color.dark
        text.textAlignment   = NSTextAlignment.right
        text.keyboardType    = UIKeyboardType.numberPad
        text.isScrollEnabled = false
        text.backgroundColor = UIColor.clear
        return text
    }()
    
    /**  */
    let minute: UITextView = {
        let text             = UITextView()
        text.font            = Font.text.m
        text.text            = format(Date().minute)
        text.textColor       = Color.dark
        text.textAlignment   = NSTextAlignment.left
        text.keyboardType    = UIKeyboardType.numberPad
        text.isScrollEnabled = false
        text.backgroundColor = UIColor.clear
        return text
    }()
    
    // MARK: - Label
    
    /**  */
    let split_label: UILabel = Views.Label.normal(":")
    
    // MARK: - Action
    
    override func sure_action() {
        if is_avaible() {
            super.sure_action()
            hour.resignFirstResponder()
            minute.resignFirstResponder()
        } else {
            update(error: "当前日期不合法")
        }
    }
    
    override func cancel_action() {
        super.cancel_action()
        hour.resignFirstResponder()
        minute.resignFirstResponder()
    }
    
    // MARK: - Bounds
    
    override func view_bounds() {
        super.view_bounds()
        
        split_label.center = CGPoint(x: container.bounds.width / 2, y: container.bounds.height / 2)
        
        hour.frame = CGRect(
            x: 8, y: (container.bounds.height - 44) / 2,
            width: split_label.frame.minX - 16, height: 44
        )
        minute.frame = CGRect(
            x: split_label.frame.maxX + 8, y: (container.bounds.height - 44) / 2,
            width: container.bounds.width - split_label.frame.maxX - 16, height: 44
        )
    }
    
    // MARK: - Text Delegate
    
    override func textViewDidChange(_ textView: UITextView) {
        if hour.text.isEmpty || minute.text.isEmpty {
            return
        }
        if textView.text.count > 2 {
            while textView.text.hasPrefix("0") {
                textView.text.remove(at: textView.text.startIndex)
            }
        }
        if !is_avaible() {
            update(error: "时间不能为 \(hour.text!):\(minute.text!)")
            
            if textView === hour {
                hour.text = Date().hour.description
            } else if textView === minute {
                minute.text = Date().minute.description
            }
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if is_avaible() {
            if textView.text.count == 1 {
                textView.text = "0\(textView.text!)"
            }
            return true
        } else {
            update(error: "时间输入不能为空")
            return false
        }
    }
    
    // MARK: - Format
    
    class func format(_ value: Int) -> String {
        if value < 10 {
            return "0\(value)"
        } else {
            return value.description
        }
    }

    func format(_ value: Int) -> String {
        return KeyboardTime.format(value)
    }
    
}
