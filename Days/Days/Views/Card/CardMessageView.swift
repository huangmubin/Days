//
//  CardMessageView.swift
//  Days
//
//  Created by Myron on 2018/5/25.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class CardMessageView: CardStandardView, KeyboardDelegate {
    
    // MARK: - Values
    
    var message: String = ""
    var placeholder: String = ""
    
    func update(text value: String?) {
        if value?.isEmpty == false {
            message = value!
            text.text = value
            text.textColor = Color.dark
        } else {
            text.text = placeholder
            text.textColor = Color.gray.halftone
        }
        let height = max(
            160,
            text.sizeThatFits(CGSize(width: bounds.width - edge.left - edge.right - 20, height: 10000)).height + title.frame.maxY + space + 20 + edge.bottom
        )
        if frame.height != height {
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.size.height = height
                self.table.update_content_size()
            })
        }
    }
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        container.addSubview(text)
        container.addSubview(input_button)
        input_button.addTarget(self, action: #selector(input_action(_:)), for: .touchUpInside)
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        text.frame = CGRect(
            x: 10, y: 10, width: container.frame.width - 20,
            height: container.frame.height - 20
        )
        input_button.frame = container.bounds
    }
    
    // MARK: - Text
    
    let text: UILabel = {
        let label = UILabel()
        label.font = Font.text.m
        label.textColor = Color.dark
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Button
    
    let input_button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    @objc func input_action(_ sender: UIButton) {
        let view = Keyboard()
        view.update(title: title.text ?? "")
        view.update(text: message)
        view.delegate = self
        view.push()
    }
    
    func keyboard(_ board: Keyboard) -> String? {
        update(text: board.value as? String)
        return nil
    }
    
}
