//
//  Keyboard.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    /** call when save，if ok, return nil, if error return the error message. */
    func keyboard(_ board: Keyboard) -> String?
}

/** 初始化后，必须调用 push() */
class Keyboard: View, UITextViewDelegate {
    
    // MARK: - View Deploy
    
    //deinit {
    //    print("Keyboard is deinit")
    //}
    
    override func view_deploy() {
        //print("Keyboard is view deploy.")
        
        addSubview(title)
        addSubview(error)
        addSubview(sure)
        addSubview(cancel)
        addSubview(container)
        container.addSubview(text)
        
        text.delegate = self
        sure.addTarget(self, action: #selector(sure_action), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(cancel_action), for: .touchUpInside)
        
        backgroundColor = Color.gray.thin
        frame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.height,
            width: UIScreen.main.bounds.width,
            height: 160
        )
        
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
    
    /** 数据 */
    var value: Any { return text.text }
    
    /** 弹出窗口 */
    func push() {
        key_window.makeKeyAndVisible()
        text.becomeFirstResponder()
    }
    
    /** 更新 title label */
    func update(title value: String) {
        title.text = value
        view_bounds()
    }
    
    /** 更新 text view */
    func update(text value: String) {
        text.text = value
        frame.size.height = frame.height + max(text.sizeThatFits(CGSize(width: container.frame.width - 20, height: 1000)).height, 44) - text.frame.height
    }
    
    // MARK: - Data
    
    /** 识别 id */
    var id: String = ""
    
    /** 代理对象 */
    weak var delegate: KeyboardDelegate?
    
    // MARK: - Window
    
    /** 背景视窗 */
    var key_window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    
    // MARK: - Title
    
    /** 标题文本 */
    let title: UILabel = {
        let label = UILabel()
        label.font = Font.title.b
        label.text = "标题"
        label.textColor = Color.dark
        return label
    }()
    
    // MARK: - Error
    
    /** 错误提示文本 */
    let error: UILabel = {
        let label = UILabel()
        label.font = Font.hint.m
        label.text = "错误提示"
        label.textColor = Color.red.light
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    /** 更新错误标签，然后显示出来，5秒后消失 */
    func update(error: String) {
        self.error.text = error
        UIView.animate(withDuration: 0.25, animations: {
            self.error.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 5, options: .curveLinear, animations: {
                self.error.alpha = 0
            }, completion: nil)
        })
    }
    
    // MARK: - Input Container
    
    /** 输入框背景视图 */
    let container: View = {
        let view = View()
        view.corner = 10
        view.backgroundColor = Color.gray.light
        return view
    }()
    
    // MARK: - Text
    
    /** 输入框 */
    let text: UITextView = {
        let text = UITextView()
        text.font = Font.text.m
        text.textColor = Color.dark
        text.backgroundColor = UIColor.clear
        text.isScrollEnabled = false
        return text
    }()
    
    // MARK: - Button
    
    /** Cancel */
    let cancel: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.tintColor = Color.gray.dark
        button.setImage(#imageLiteral(resourceName: "but_cancel"), for: .normal)
        return button
    }()
    
    /** Sure */
    let sure: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.tintColor = Color.gray.dark
        button.setImage(#imageLiteral(resourceName: "but_sure"), for: .normal)
        return button
    }()
    
    @objc func cancel_action() {
        text.resignFirstResponder()
    }
    
    @objc func sure_action() {
        if let error = delegate?.keyboard(self) {
            update(error: error)
        } else {
            text.resignFirstResponder()
        }
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        let space: CGFloat = 20
        let x_cen: CGFloat = bounds.width - 76
        let y_cen: CGFloat = 76
        
        title.sizeToFit()
        title.frame.origin = CGPoint(x: space, y: space)
        title.frame.size.width = min(x_cen, title.frame.width)
        
        error.frame = CGRect(
            x: title.frame.maxX + 8,
            y: title.frame.minY,
            width: max(x_cen - title.frame.maxX - 8, 0),
            height: error.sizeThatFits(CGSize(width: max(x_cen - title.frame.maxX - 8, 0), height: 1000)).height
        )
        
        container.frame = CGRect(
            x: 20, y: y_cen,
            width: x_cen - 20,
            height: frame.height - y_cen - 20
        )
        
        text.frame = CGRect(
            x: 10, y: 10,
            width: container.frame.width - 20, // (20 10 10)
            height: container.frame.height - 20
        )
        
        sure.frame = CGRect(
            x: x_cen + 8, y: y_cen,
            width: 60, height: 60
        )
        
        cancel.frame = CGRect(
            x: x_cen + 8, y: 8,
            width: 60, height: 60
        )
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        let offset = max(text.sizeThatFits(CGSize(width: container.frame.width - 20, height: 1000)).height, 44) - text.frame.height
        if (frame.origin.y <= 0 && offset < 0) || (frame.origin.y > 0) {
            let h = min(keyboard_minY, frame.height + offset)
            let y = max(0, frame.minY - offset)
            text.isScrollEnabled = (y == 0)
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y = y
                self.frame.size.height = h
            })
        }
    }
    
    // MARK: - Keyboard Observer
    
    @objc func keyboard_will_change_frame(_ notification: Notification) {
        if let info = notification.userInfo {
            if let rect = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                self.keyboard_will_change_frame(keyboard: rect.cgRectValue)
            }
        }
    }
    
    /** Temp value */
    private var keyboard_minY: CGFloat = 0
    /** keyboard will change to the new rect */
    func keyboard_will_change_frame(keyboard rect: CGRect) {
        keyboard_minY = rect.minY
        if rect.minY < UIScreen.main.bounds.height {
            let y = max(keyboard_minY - frame.height, 0)
            let h = min(frame.height, keyboard_minY)
            text.isScrollEnabled = (y == 0)
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y = y
                self.frame.size.height = h
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y = rect.minY
                self.key_window.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
                self.key_window.isHidden = true
            })
        }
    }
    
}
