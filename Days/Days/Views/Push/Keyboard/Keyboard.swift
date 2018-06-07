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
class Keyboard: PushView, UITextViewDelegate {
    
    // MARK: - View Deploy
    
    //deinit {
    //    print("Keyboard is deinit")
    //}
    
    override func view_deploy() {
        //print("Keyboard is view deploy.")
        super.view_deploy()
        
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
    }
    
    // MARK: - Interface
    
    /** 数据 */
    var value: Any { return text.text }
    
    /** 弹出窗口 */
    override func push() {
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
    
    /** 代理对象 */
    weak var delegate: KeyboardDelegate?
    
    // MARK: - Title
    
    /** 标题文本 */
    let title: UILabel = Views.Label.normal("标题")
    
    // MARK: - Error
    
    /** 错误提示文本 */
    let error: UILabel = Views.Label.warning(hint: "错误提示", line: 0)
    
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
    let cancel: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_cancel"), tint: Color.gray.dark)
    
    /** Sure */
    let sure: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_sure"), tint: Color.gray.dark)
    
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
        title.frame.origin = CGPoint(x: space, y: (y_cen - title.frame.height) / 2)
        title.frame.size.width = min(x_cen, title.frame.width)
        
        error.frame = CGRect(
            x: title.frame.maxX + 8,
            y: 0,
            width: max(x_cen - title.frame.maxX - 8, 0),
            height: y_cen
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
    
    override func keyboard_open(rect: CGRect) {
        let y = max(keyboard_minY - frame.height, 0)
        let h = min(frame.height, keyboard_minY)
        text.isScrollEnabled = (y == 0)
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.y = y
            self.frame.size.height = h
        })
    }
    
    override func keyboard_close(rect: CGRect) {
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.y = rect.minY
            self.key_window.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
            self.key_window.isHidden = true
        })
    }
}
