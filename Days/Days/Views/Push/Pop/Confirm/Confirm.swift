//
//  Confirm.swift
//  Days
//
//  Created by 黄穆斌 on 2018/5/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol ConfirmDelegate: class {
    func confirm(_ view: Confirm)
}

class Confirm: PushView {
    
    // MARK: - View Deploy
    
    //deinit {
    //    print("Keyboard is deinit")
    //}
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(back)
        back.addSubview(title)
        addSubview(sure)
        addSubview(cancel)
        
        sure.addTarget(self, action: #selector(sure_action), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(cancel_action), for: .touchUpInside)
        
        clipsToBounds = true
        backgroundColor = Color.gray.light
        layer.cornerRadius = 20
        frame = CGRect(
            x: 30, y: UIScreen.main.bounds.height,
            width: UIScreen.main.bounds.width - 60,
            height: 160
        )
    }
    
    // MARK: - Interface
    
    weak var delegate: ConfirmDelegate?
    
    override func push() {
        key_window.makeKeyAndVisible()
        let y = (UIScreen.main.bounds.height - frame.height) / 2
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.y = y
        })
    }
    
    func update(title value: String) {
        title.text = value
        title.frame = back.bounds
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        back.frame = CGRect(
            x: 10, y: 10,
            width: bounds.width - 20,
            height: bounds.height - 80
        )
        
        title.center = CGPoint(
            x: back.frame.width / 2,
            y: back.frame.height / 2
        )
        
        sure.frame = CGRect(
            x: 10, y: bounds.height - 60,
            width: bounds.width / 2 - 15,
            height: 50
        )
        cancel.frame = CGRect(
            x: sure.frame.maxX + 10,
            y: sure.frame.minY,
            width: sure.bounds.width,
            height: sure.bounds.height
        )
    }
    
    // MARK: - Back
    
    /** 文本背景 */
    let back: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = Color.white
        return view
    }()
    
    // MARK: - Labels
    
    /** 标题文本 */
    let title: UILabel = {
        let label = UILabel()
        label.font = Font.text.m
        label.text = "标题"
        label.textColor = Color.dark
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Buttons
    
    /** 确认 */
    let sure: UIButton = {
        let button = Button(type: .system)
        button.setTitle("确认", for: .normal)
        button.setTitleColor(Color.dark, for: .normal)
        button.corner = 10
        button.titleLabel?.font = Font.text.m
        button.normal_color = Color.white
        return button
    }()
    
    /** Cancel */
    let cancel: UIButton = {
        let button = Button(type: .system)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(Color.dark, for: .normal)
        button.corner = 10
        button.titleLabel?.font = Font.text.m
        button.normal_color = Color.white
        return button
    }()
    
    @objc func sure_action() {
        animation({ self.delegate?.confirm(self) })
    }
    
    @objc func cancel_action() {
        animation({})
    }
    
    func animation(_ complete: @escaping () -> Void) {
        let rect = CGRect(
            x: frame.origin.x - 10,
            y: frame.origin.y - 10,
            width: frame.width + 20,
            height: frame.height + 20
        )
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveLinear, animations: {
            self.frame = rect
        }, completion: { _ in
            complete()
            self.removeFromSuperview()
            self.key_window.isHidden = true
        })
        UIView.animate(withDuration: 0.75, delay: 0.25, options: .curveLinear, animations: {
            self.alpha = 0.25
        }, completion: nil)
    }
    
}
