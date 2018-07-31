//
//  RootMenu.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class RootMenu: View {
    
    // MARK: - Values
    
    weak var controller: RootController!
    
    // MARK: - Action
    
    @objc func user_actions(_ sender: UIButton) {
        controller.view_push(index: sender.tag, sender: sender)
    }
    
    // MARK: - Sub View
    
    let scroll: UIScrollView = UIScrollView()
    
    let append: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(#imageLiteral(resourceName: "ui_menu_append"), for: .normal)
        return view
    }()
    
    var buttons: [[TeletextButton]] = []
    var lines: [UIView] = []
    
    // MARK: - View
    
    /** Set the buttons and lines */
    func load_buttons() {
        
    }
    
    override func view_deploy() {
        super.view_deploy()
        load_buttons()
        
        addSubview(scroll)
        
        for (s, section) in buttons.enumerated() {
            for (r, button) in section.enumerated() {
                button.tag = s * 10 + r
                button.label.font = Font.regular(12)
                button.addTarget(self, action: #selector(user_actions(_:)), for: .touchUpInside)
                scroll.addSubview(button)
            }
        }
        
        for line in lines {
            line.backgroundColor = Color.gray.light
            line.layer.cornerRadius = 0.5
            scroll.addSubview(line)
        }
        
        addSubview(append)
        append.tag = 1000
        append.addTarget(self, action: #selector(user_actions(_:)), for: .touchUpInside)
        
        clipsToBounds = true
        scroll.clipsToBounds = false
    }
    
    override func view_bounds() {
        super.view_deploy()
        if frame.size.height == 0 {
            let columns: Int = UIDevice.iPhone() ? 2 : 1
            let edge: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            let size: CGSize = CGSize(
                width: (bounds.width - edge.left - edge.right - CGFloat(columns - 1) * 10) / CGFloat(columns),
                height: 60
            )
            let height = size.height + 10
            var x: CGFloat = edge.left
            var y: CGFloat = edge.top
            
            for (s, section) in buttons.enumerated() {
                for (r, button) in section.enumerated() {
                    x = edge.left + CGFloat(r % columns) * size.width
                    button.frame = CGRect(
                        x: x, y: y + CGFloat(r / columns) * height,
                        width: size.width, height: size.height
                    )
                }
                y = y + CGFloat((section.count - 1) / columns + 1) * height - 10
                
                if s < lines.count {
                    lines[s].frame = CGRect(
                        x: edge.left + bounds.width * 0.05,
                        y: y + 16,
                        width: bounds.width * 0.9 - edge.left - edge.right,
                        height: 1
                    )
                    y = y + 33
                }
            }
            y += edge.bottom
            
            if UIDevice.iPhone() {
                self.frame.size.height = min(y, App.Screen.height * 0.5)
            } else {
                self.frame.size.height = App.Screen.content
            }
            
            scroll.frame = bounds
            scroll.contentSize = CGSize(
                width: bounds.width,
                height: y
            )
            
            if columns == 1 {
                append.frame = CGRect(
                    x: (bounds.width - 60) / 2,
                    y: bounds.height - 80,
                    width: 60, height: 60
                )
                append.isHidden = false
                scroll.frame.size.height -= 90
            } else {
                append.isHidden = true
            }
        }
    }
}
