//
//  HabitBoothUnitCard.swift
//  Days
//
//  Created by Myron on 2018/5/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitBoothUnitCard: CardStandardView {
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        title.isHidden = true
        //edge = UIEdgeInsets(top: 10, left: edge.left, bottom: 0, right: edge.right)
        
        container.backgroundColor = Color.white
        
        container.addSubview(done)
        container.addSubview(list)
        container.addSubview(sock)
        
        done.addTarget(self, action: #selector(done_action), for: .touchUpInside)
        list.addTarget(self, action: #selector(list_action), for: .touchUpInside)
        sock.addTarget(self, action: #selector(sock_action), for: .touchUpInside)
    }
    
    override func view_bounds() {
        super.view_bounds()
        container.frame = CGRect(
            x: edge.left, y: edge.top,
            width: bounds.width - edge.left - edge.right,
            height: bounds.height - edge.top - edge.bottom
        )
        
        done.frame = CGRect(
            x: 0, y: 0,
            width: (container.frame.width - 30) / 4,
            height: container.frame.height
        )
        list.frame = CGRect(
            x: done.frame.maxX + 10, y: 0,
            width: done.frame.width * 2 + 10,
            height: done.frame.height
        )
        sock.frame = CGRect(
            x: list.frame.maxX + 10, y: 0,
            width: done.frame.width,
            height: done.frame.height
        )
    }
    
    // MARK: - Buttons
    
    let done: Button = {
        let button = Button(type: .system)
        button.normal_color = Color.gray.light
        button.corner = 10
        button.setTitle("打卡", for: .normal)
        button.titleLabel?.font = Font.text.b
        button.setTitleColor(Color.dark, for: .normal)
        return button
    }()
    
    let sock: Button = {
        let button = Button(type: .system)
        button.normal_color = Color.gray.light
        button.corner = 10
        button.setTitle("请假", for: .normal)
        button.titleLabel?.font = Font.text.b
        button.setTitleColor(Color.dark, for: .normal)
        return button
    }()
    
    let list: Button = {
        let button = Button(type: .system)
        button.normal_color = Color.gray.light
        button.corner = 10
        button.setTitle("详细记录", for: .normal)
        button.titleLabel?.font = Font.text.b
        button.setTitleColor(Color.dark, for: .normal)
        return button
    }()
    
    @objc func done_action() {
        let unit = HabitUnit(habit)
        table.controller?.performSegue(withIdentifier: "UnitEdit", sender: unit)
    }
    @objc func sock_action() {
        let unit = HabitUnit(habit)
        unit.obj.is_sick = true
        table.controller?.performSegue(withIdentifier: "UnitEdit", sender: unit)
    }
    @objc func list_action() {
        table.controller?.performSegue(withIdentifier: "UnitList", sender: habit.date)
    }
}
