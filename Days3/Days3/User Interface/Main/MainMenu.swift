//
//  MainMenu.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MainMenu: View {
    
    // MARK: - Values
    
    weak var controller: MainController!
    
    // MARK: - Action
    
    func update(column col: Int) -> CGFloat {
        columns = col
        view_bounds()
        return scroll.contentSize.height
    }
    
    @objc func user_actions(_ sender: UIButton) {
        print("user_actions = \(sender.tag) - \(String(describing: (sender as? LabelButton)?.label.text))")
    }
    
    // MARK: - Sub View
    
    let scroll: UIScrollView = UIScrollView()
    
    let append: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(#imageLiteral(resourceName: "ui_menu_append"), for: .normal)
        return view
    }()
    var buttons: [[LabelButton]] = [
        [
            LabelButton(image: #imageLiteral(resourceName: "ui_menu_project"), text: "添加项目".language),
            LabelButton(image: #imageLiteral(resourceName: "ui_menu_habit"), text: "相加习惯".language),
            LabelButton(image: #imageLiteral(resourceName: "ui_menu_habit"), text: "相加习惯".language),
        ],
        [
            LabelButton(image: #imageLiteral(resourceName: "ui_menu_timer"), text: "定时器".language),
            LabelButton(image: #imageLiteral(resourceName: "ui_menu_counter"), text: "计步器".language),
        ],
        [
            LabelButton(image: #imageLiteral(resourceName: "ui_menu_projects"), text: "项目列表".language),
            LabelButton(image: #imageLiteral(resourceName: "ui_menu_habits"), text: "习惯列表".language),
        ],
    ]
    var lines: [UIView] = [UIView(), UIView()]
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        self.backgroundColor = UIColor.red
        addSubview(scroll)
        for (s, section) in buttons.enumerated() {
            for (r, button) in section.enumerated() {
                button.tag = s * 10 + r
                button.addTarget(self, action: #selector(user_actions(_:)), for: .touchUpInside)
                button.backgroundColor = UIColor.blue
                scroll.addSubview(button)
            }
        }
        for line in lines {
            line.backgroundColor = Color.gray.light
            line.layer.cornerRadius = 0.5
            scroll.addSubview(line)
        }
    }
    
    private var columns: Int = 2
    override func view_bounds() {
        super.view_deploy()
        let edge: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let size: CGSize = CGSize(
            width: (bounds.width - edge.left - edge.right - CGFloat(columns - 1) * 10) / CGFloat(columns),
            height: 60
        )
        var x: CGFloat = edge.left
        var y: CGFloat = edge.top
        
        for (s, section) in buttons.enumerated() {
            for (r, button) in section.enumerated() {
                x = edge.left + CGFloat(r % columns) * size.width
                y = y + CGFloat(r / columns) * size.height
                button.frame = CGRect(
                    x: x, y: y,
                    width: size.width, height: size.height
                )
            }
            y = y + size.height
            
            if s < lines.count {
                lines[s].frame = CGRect(
                    x: edge.left, y: y + 9,
                    width: bounds.width - edge.left - edge.right,
                    height: 1
                )
                y = y + 19
            }
        }
        
        scroll.frame = bounds
        scroll.contentSize = CGSize(
            width: bounds.width,
            height: y + edge.bottom
        )
    }
    
}
