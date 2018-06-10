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
    let title: UILabel = Views.Label.title(small: "标题")
    
    // MARK: - Error
    
    /** 错误提示文本 */
    let error: UILabel = Views.Label.warning(hint: "错误提示", line: 0, alignment: .left)
    
    private var _error_timer: Timer? = nil
    /** 更新错误标签，然后显示出来，5秒后消失 */
    func update(error: String) {
        self.error.text = error
        
        if _error_timer == nil {
            _error_timer = Timer()
            _error_timer?.delegate = self
            _error_timer?.run(second: 4)
        } else {
            _error_timer?.time = 4
        }
        
        let height = self.title.frame.height + self.error.frame.height
        
        let new_title_rect = CGRect(
            x: self.title.frame.origin.x,
            y: max(8, (self.container.frame.minY - height) / 2),
            width: self.title.frame.width,
            height: self.title.frame.height
        )
        let new_error_rect = CGRect(
            x: self.error.frame.origin.x,
            y: new_title_rect.maxY,
            width: self.error.frame.width,
            height: self.error.frame.height
        )
        
        UIView.animate(withDuration: 0.25, animations: {
            self.error.alpha = 1
            self.title.frame = new_title_rect
            self.error.frame = new_error_rect
        })
    }
    
    override func timer_finish(total: Int, time: Int, interval: DispatchTimeInterval) {
        let title_rect = CGRect(
            x: space,
            y: (container.frame.minY - title.frame.height) / 2,
            width: title.frame.width,
            height: title.frame.height
        )
        let error_rect = CGRect(
            x: title_rect.origin.x,
            y: title_rect.maxY,
            width: error.frame.width,
            height: error.frame.height
        )
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
            self.error.alpha = 0
            self.title.frame = title_rect
            self.error.frame = error_rect
        }, completion: nil)
        _error_timer = nil
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
        _need_remove = true
        text.resignFirstResponder()
    }
    
    @objc func sure_action() {
        if let error = delegate?.keyboard(self) {
            update(error: error)
        } else {
            _need_remove = true
            text.resignFirstResponder()
        }
    }
    
    // MARK: - Frame
    
    let space: CGFloat = 20
    override func view_bounds() {
        let x_cen: CGFloat = bounds.width - 76
        let y_cen: CGFloat = 76

        title.sizeToFit()
        title.frame.origin = CGPoint(x: space, y: (y_cen - title.frame.height) / 2)
        title.frame.size.width = min(x_cen, title.frame.width)

//        error.frame = CGRect(
//            x: title.frame.maxX + 8,
//            y: 0,
//            width: max(x_cen - title.frame.maxX - 8, 0),
//            height: y_cen
//        )
//
//        title.sizeToFit()
//        title.frame.origin = CGPoint(x: space, y: 10)
//        title.frame.size.width = min(x_cen, title.frame.width)
        
        error.frame = CGRect(
            x: title.frame.minX,
            y: title.frame.maxY,
            width: x_cen - title.frame.minX,
            height: y_cen - title.frame.maxY
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
    
    override func orientation_changed(rect: CGRect) {
        let new = CGRect(
            x: frame.origin.x, y: frame.origin.y,
            width: rect.width, height: frame.height
        )
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = new
        })
    }
    
    private var _need_remove: Bool = false
    
    override func keyboard_change(rect: CGRect) {
        if !_need_remove {
            let y = max(keyboard_minY - frame.height, 0)
            let h = min(frame.height, keyboard_minY)
            text.isScrollEnabled = (y == 0)
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.origin.y = y
                self.frame.size.height = h
            })
        }
    }
    
    override func keyboard_close(rect: CGRect) {
        if _need_remove {
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
