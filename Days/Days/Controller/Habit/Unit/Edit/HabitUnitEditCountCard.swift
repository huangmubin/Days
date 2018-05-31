//
//  HabitUnitEditCountCard.swift
//  Days
//
//  Created by Myron on 2018/5/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitEditCountCard: CardStandardView {

    override func reload() {
        super.reload()
        number.text = unit_obj.obj.length.description
        update_text()
    }
    
    // MARK: - View Deploy
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "次数"
        container.backgroundColor = Color.white
        
        container.addSubview(push)
        container.addSubview(decrease)
        container.addSubview(increase)
        container.addSubview(number)
        container.addSubview(unit)
        
        push.addTarget(self, action: #selector(push_action), for: .touchUpInside)
        decrease.addTarget(self, action: #selector(decrease_action), for: .touchUpInside)
        increase.addTarget(self, action: #selector(increase_action), for: .touchUpInside)
    }
    
    override func view_bounds() {
        super.view_bounds()
        decrease.frame = CGRect(
            x: 0, y: 0,
            width: container.bounds.height,
            height: container.bounds.height
        )
        push.frame = CGRect(
            x: decrease.frame.maxX + 10, y: 0,
            width: container.bounds.width - 20 - container.bounds.height * 2,
            height: container.bounds.height
        )
        increase.frame = CGRect(
            x: push.frame.maxX + 10, y: 0,
            width: container.bounds.height,
            height: container.bounds.height
        )
        update_text()
    }
    
    func update_text() {
        number.sizeToFit()
        unit.sizeToFit()
        number.center = CGPoint(
            x: push.center.x - unit.bounds.width / 2 - 4,
            y: push.center.y
        )
        unit.center = CGPoint(
            x: push.center.x + number.bounds.width / 2 + 4,
            y: number.center.y
        )
    }
    
    // MARK: - Push
    
    let push: Button = {
        let button = Button(type: .custom)
        button.normal_color = Color.gray.light
        button.corner = 10
        button.titleLabel?.font = Font.title.m
        button.setTitleColor(Color.dark, for: .normal)
        return button
    }()
    
    @objc func push_action() {
        let key = Keyboard()
        key.text.keyboardType = .numberPad
        key.delegate = self
        key.update(title: "多少次")
        key.update(text: "\(unit_obj.obj.length)")
        key.push()
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        guard let text = board.value as? String else {
            return "输入不合法"
        }
        guard let int = Int(text) else {
            return "输入不合法"
        }
        if int <= 0 {
            return "输入不合法"
        }
        unit_obj.obj.length = int
        reload()
        return nil
    }
    
    // MARK: - Step
    
    let increase: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = Font.text.b
        button.tintColor = Color.dark
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        return button
    }()
    let decrease: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = Font.text.b
        button.tintColor = Color.dark
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func increase_action() {
        unit_obj.obj.length = unit_obj.obj.length + 1
        reload()
    }
    @objc func decrease_action() {
        unit_obj.obj.length = max(1, unit_obj.obj.length - 1)
        reload()
    }
    
    // MARK: - Labels
    
    let number: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = Font.text.b
        label.textColor = Color.dark
        return label
    }()
    
    let unit: UILabel = {
        let label = UILabel()
        label.text = "次"
        label.font = Font.text.s
        label.textColor = Color.gray.halftone
        return label
    }()
    

}
