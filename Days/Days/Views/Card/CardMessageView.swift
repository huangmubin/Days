//
//  CardMessageView.swift
//  Days
//
//  Created by Myron on 2018/5/25.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class CardMessageView: CardStandardView {
    
    // MARK: - Values
    
    /** value */
    var message: String = ""
    /** When message is empty, show the placeholder */
    var placeholder: String = ""
    
    /** text edge to the container */
    var text_edge: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    /** Override: Call when update message */
    func update(message: String) { }
    
    /** Update the text and resize. */
    func update(text value: String?) {
        if value?.isEmpty == false {
            message = value!
            text.text = value
            text.textColor = Color.dark
        } else {
            text.text = placeholder
            text.textColor = Color.gray.halftone
        }
        
        let text_height = text.sizeThatFits(
            CGSize(
                width: bounds.width - edge.left - edge.right - text_edge.left - text_edge.right,
                height: 10000
            )
        ).height
        let height = max(
            160,
            title.frame.maxY + space + text_edge.top + text_height + text_edge.bottom + edge.bottom
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
    
    override var default_height: CGFloat { return 160 }
    
    override func view_bounds() {
        super.view_bounds()
        text.frame = CGRect(
            x: text_edge.left, y: text_edge.top,
            width: container.frame.width - text_edge.left - text_edge.right,
            height: container.frame.height - text_edge.top - text_edge.bottom
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
    
    override func keyboard(_ board: Keyboard) -> String? {
        update(text: board.value as? String)
        update(message: message)
        return nil
    }
    
}
