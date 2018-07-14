//
//  HabitEditCallCard.swift
//  Days
//
//  Created by Myron on 2018/7/13.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditCallCard: CardStandardView {
    
    // MARK: - View Deploy
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "每日提醒"
        
        addSubview(open)
        open.addTarget(self, action: #selector(open_action), for: .valueChanged)
        
        container.clipsToBounds = true
        
        for day in days {
            container.addSubview(day)
            day.addTarget(self, action: #selector(days_action(_:)), for: .touchUpInside)
        }
        container.addSubview(time)
        time.gradient_color = container.backgroundColor!
        
    }
    
    override func reload() {
        super.reload()
        // TODO: habit days
        for day in days {
            day.isSelected = false
            days_action(day)
        }
    }
    
    // MARK: - View Bounds
    
    override func view_bounds() {
        //super.view_bounds()
        title.frame = CGRect(
            x: edge.left,
            y: edge.top,
            width: bounds.width - edge.left - edge.right - open.frame.width,
            height: 30
        )
        
        open.center = CGPoint(
            x: title.frame.maxX + open.frame.width / 2,
            y: title.center.y
        )
        
        container.frame = CGRect(
            x: edge.left,
            y: title.frame.maxY + space,
            width: bounds.width - edge.left - edge.right,
            height: 180
        )
        
        var x: CGFloat = 10, y: CGFloat = 10
        var w: CGFloat = 0, h: CGFloat = 0
        let s: CGFloat = 4
        
        w = container.bounds.width * 0.25
        h = (container.bounds.height - 20 - s * 3) * 0.25
        
        for (i, day) in days.enumerated() {
            day.frame = CGRect(
                x: x + CGFloat(i % 2) * (w + s),
                y: y + CGFloat(i / 2) * (h + s),
                width: w,
                height: h
            )
        }
        days.last!.frame.size.width = w * 2 + s
        
        x = x + w * 2 + s + s
        time.frame = CGRect(
            x: x,
            y: y,
            width: container.bounds.width - y - x,
            height: container.frame.height - y - y
        )
    }
    
    // MARK: - open
    
    var is_open: Bool { return open.isOn }
    
    let open: UISwitch = {
        let button = UISwitch(frame: CGRect.zero)
        button.isOn = false
        return button
    }()
    
    @objc func open_action() {
        open.isUserInteractionEnabled = false
        let h = is_open ? (container.frame.maxY + edge.bottom) : default_height
        let y = (is_open ? (h - default_height) : 0) + table.contentOffset.y
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.size.height = h
            self.table.contentOffset.y = y
            self.table.update_content_size()
        }, completion: { _ in
            self.open.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - Days
    
    let days: [UIButton] = {
        var buttons = [UIButton]()
        for i in ["一", "二", "三", "四", "五", "六", "日"] {
            let button = Views.Button.normal(title: i)
            button.tintColor = UIColor.clear
            button.setTitleColor(Color.dark, for: .normal)
            button.setTitleColor(Color.white, for: .selected)
            buttons.append(button)
        }
        return buttons
    }()
    
    @objc func days_action(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? habit.color : UIColor.clear
    }
    
    // MARK: - timer
    
    let time: iSelectorCombine.Time = {
        let view = iSelectorCombine.Time()
        view.label = Views.Label.normal("")
        view.update_label()
        view.update_space()
        return view
    }()
    
}
