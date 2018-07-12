//
//  KeyboardType.swift
//  Days
//
//  Created by Myron on 2018/7/12.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class KeyboardType: Keyboard {
    
    override var value: Any {
        for type in types {
            if type.isSelected {
                return type.title(for: .normal) ?? ""
            }
        }
        return text.text
    }
    
    // MARK: - Types
    
    /** 可选的类型 */
    private var types: [UIButton] = []
    
    private func type(button: UIButton, select: Bool) {
        button.isSelected = select
        button.backgroundColor = select ? select_color : Color.gray.light
    }
    
    var select_color: UIColor = Color.gray.dark
    
    func reload(types values: [String]) {
        types.forEach({ $0.removeFromSuperview() })
        types.removeAll(keepingCapacity: true)
        for (i, value) in values.enumerated() {
            let button = Views.Button.small(title: value)
            button.tag = i
            type(button: button, select: false)
            button.setTitleColor(Color.dark, for: .normal)
            button.setTitleColor(Color.white, for: .selected)
            button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
            button.addTarget(self, action: #selector(type_action(_:)), for: .touchUpInside)
            addSubview(button)
            types.append(button)
        }
        self.frame.size.height = default_height + types_height() + 16
        view_bounds()
        
        if let index = values.index(where: { $0 == text.text }) {
            type(button: types[index], select: true)
            text.text = ""
            placeholder.alpha = 1
        } else {
            placeholder.alpha = 0
        }
    }
    
    @objc func type_action(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            type(button: sender, select: true)
            for button in types {
                if button !== sender {
                    type(button: button, select: false)
                }
            }
            text.text = ""
            UIView.animate(withDuration: 0.25, animations: {
                self.placeholder.alpha = 1
            })
        }
    }
    
    // MARK: - View Bounds
    
    var type_height: CGFloat { return 34 }
    
    func types_height() -> CGFloat {
        let i = (types.count - 1) / 3
        return CGFloat(i + 1) * type_height + CGFloat(i) * 4
    }
    
    override func view_bounds() {
        let x_cen: CGFloat = bounds.width - 76
        var y_cen: CGFloat = 76
        
        title.sizeToFit()
        title.frame.origin = CGPoint(x: space, y: (y_cen - title.frame.height) / 2)
        title.frame.size.width = min(x_cen, title.frame.width)
        
        error.center = CGPoint(
            x: (x_cen - title.frame.maxX) / 2 + title.frame.maxX,
            y: title.center.y
        )
        
//        y_cen += 8
        
        let w = (x_cen - 20 - 8) / 3
        for type in types {
            type.frame = CGRect(
                x: CGFloat(type.tag % 3) * (w + 3) + 20,
                y: CGFloat(type.tag / 3) * 34 + y_cen,
                width: w,
                height: type_height
            )
        }
        
        print(types.count)
        y_cen = y_cen + types_height() + 16
        
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
        placeholder.frame = CGRect(
            x: 16, y: 18,
            width: container.frame.width - 20, // (20 10 10)
            height: placeholder.frame.height
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
    
    // MARK: - Text

    let placeholder: UILabel = Views.Label.normal("自定义", alignment: .left)
    
    override func view_deploy() {
        super.view_deploy()
        container.addSubview(placeholder)
        placeholder.textColor = Color.gray.halftone
        error.text = "单位不易过长"
        error.sizeToFit()
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        if textView.text.isEmpty {
            if !types.contains(where: { $0.isSelected }) {
                type(button: types[0], select: true)
            }
            placeholder.alpha = 1
        } else {
            types.forEach({
                self.type(button: $0, select: false)
            })
            placeholder.alpha = 0
        }
    }

    // MARK: - Error
    
    override func error_open_animate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.error.alpha = 1
        })
    }
    
    override func error_close_animate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.error.alpha = 0
        })
    }
    
}
