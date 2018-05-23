//
//  KeyboardDate.swift
//  Days
//
//  Created by 黄穆斌 on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class KeyboardDate: Keyboard {
    
    // MARK: - View Deploy
    
    override func view_deploy() {
        super.view_deploy()
        container.addSubview(year)
        container.addSubview(month)
        container.addSubview(day)
        container.addSubview(year_label)
        container.addSubview(month_label)
        
        year.delegate  = self
        month.delegate = self
        day.delegate   = self
        
        text.isHidden = true
    }
    
    // MARK: - Interface
    
    /**  */
    override var value: Any {
        if is_avaible() {
            let date = Int(year.text)! * 10000 + Int(month.text)! * 100 + Int(day.text)!
            return Date(date)
        }
        return Date()
    }
    
    /** 弹出窗口 */
    override func push() {
        key_window.makeKeyAndVisible()
        day.becomeFirstResponder()
    }
    
    /** Update the date */
    func update(date: Date) {
        year.text  = date.year.description
        month.text = date.month.description
        day.text   = date.day.description
    }
    
    /***/
    func is_avaible() -> Bool {
        if year.text.isEmpty || month.text.isEmpty || day.text.isEmpty {
            return false
        }
        guard let y = Int(year.text), let m = Int(month.text), let d = Int(day.text) else {
            return false
        }
        if y < 1 || m < 1 || d < 1 {
            return false
        }
        if y > 4000 {
            return false
        }
        if m > 12 {
            return false
        }
        if d > Date(y * 10000 + m * 100 + 1).days(.month) {
            return false
        }
        return true
    }
    
    // MARK: - Texts
    
    /**  */
    let year: UITextView = {
        let text             = UITextView()
        text.font            = Font.text.m
        text.text            = Date().year.description
        text.textColor       = Color.dark
        text.textAlignment   = NSTextAlignment.center
        text.keyboardType    = UIKeyboardType.numberPad
        text.isScrollEnabled = false
        text.backgroundColor = UIColor.clear
        return text
    }()
    
    /**  */
    let month: UITextView = {
        let text             = UITextView()
        text.font            = Font.text.m
        text.text            = Date().month.description
        text.textColor       = Color.dark
        text.textAlignment   = NSTextAlignment.center
        text.keyboardType    = UIKeyboardType.numberPad
        text.isScrollEnabled = false
        text.backgroundColor = UIColor.clear
        return text
    }()
    
    /**  */
    let day: UITextView = {
        let text             = UITextView()
        text.font            = Font.text.m
        text.text            = Date().day.description
        text.textColor       = Color.dark
        text.textAlignment   = NSTextAlignment.center
        text.keyboardType    = UIKeyboardType.numberPad
        text.isScrollEnabled = false
        text.backgroundColor = UIColor.clear
        return text
    }()
    
    // MARK: - Label
    
    /**  */
    let year_label: UILabel = {
        let label = UILabel()
        label.font = Font.text.m
        label.text = "年"
        label.textColor = Color.dark
        label.sizeToFit()
        return label
    }()
    
    /**  */
    let month_label: UILabel = {
        let label = UILabel()
        label.font = Font.text.m
        label.text = "月"
        label.textColor = Color.dark
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Action
    
    override func sure_action() {
        if is_avaible() {
            super.sure_action()
            year.resignFirstResponder()
            month.resignFirstResponder()
            day.resignFirstResponder()
        } else {
            update(error: "当前日期不合法")
        }
    }
    
    override func cancel_action() {
        year.resignFirstResponder()
        month.resignFirstResponder()
        day.resignFirstResponder()
    }
    
    // MARK: - Bounds
    
    override func view_bounds() {
        super.view_bounds()
        let w = (container.bounds.width - year_label.frame.width - month_label.frame.width - 16) / 4
        
        year.frame = CGRect(
            x: 8, y: (container.bounds.height - 44) / 2,
            width: w * 2, height: 44
        )
        year_label.frame.origin = CGPoint(
            x: year.frame.maxX, y: (container.bounds.height - year_label.frame.height) / 2
        )
        month.frame = CGRect(
            x: year_label.frame.maxX, y: year.frame.minY,
            width: w, height: year.frame.height
        )
        month_label.frame.origin = CGPoint(
            x: month.frame.maxX, y: (container.bounds.height - month_label.frame.height) / 2
        )
        day.frame = CGRect(
            x: month_label.frame.maxX, y: year.frame.minY,
            width: w, height: year.frame.height
        )
    }
    
    // MARK: - Text Delegate
    
    override func textViewDidChange(_ textView: UITextView) {
        if year.text.isEmpty || month.text.isEmpty || day.text.isEmpty {
            return
        }
        if !is_avaible() {
            if textView === year {
                update(error: "年份不能为 \(year.text!)")
                year.text = Date().year.description
            } else if textView === month {
                month.text = Date().month.description
                update(error: "月份只能是 1-12")
            } else {
                update(error: "\(year.text!)年\(month.text!)月没有\(day.text!)日")
                day.text = Date().day.description
            }
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if is_avaible() {
            return true
        } else {
            update(error: "日期输入不能为空")
            return false
        }
    }
    
}
