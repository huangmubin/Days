//
//  HabitUnitEditTypeCard.swift
//  Days
//
//  Created by Myron on 2018/5/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitEditTypeCard: CardStandardView {

    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "类型"
        container.backgroundColor = Color.white
        
        container.addSubview(normal)
        container.addSubview(sick)
        
        normal.addTarget(self, action: #selector(normal_action), for: .touchUpInside)
        sick.addTarget(self, action: #selector(sick_action), for: .touchUpInside)
    }
    
    override func reload() {
        super.reload()
        if unit_obj.obj.is_sick {
            normal.setTitleColor(Color.dark, for: .normal)
            normal.backgroundColor = Color.gray.light
            sick.setTitleColor(Color.white, for: .normal)
            sick.backgroundColor = unit_obj.habit.color
        } else {
            normal.setTitleColor(Color.white, for: .normal)
            normal.backgroundColor = unit_obj.habit.color
            sick.setTitleColor(Color.dark, for: .normal)
            sick.backgroundColor = Color.gray.light
        }
    }
    
    override func view_bounds() {
        super.view_bounds()
        normal.frame = CGRect(
            x: 0, y: 0,
            width: container.bounds.width / 2 - 10,
            height: container.bounds.height
        )
        sick.frame = CGRect(
            x: normal.frame.maxX + 20, y: 0,
            width: normal.frame.width,
            height: normal.frame.height
        )
    }
    
    // MARK: - Buttons
    
    let normal: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("正常", for: .normal)
        button.titleLabel?.font = Font.text.b
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        return button
    }()
    
    let sick: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("请假", for: .normal)
        button.titleLabel?.font = Font.text.b
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func normal_action() {
        unit_obj.obj.is_sick = false
        reload()
        (table.controller as? HabitUnitEditController)?.update_unit_type()
    }
    @objc func sick_action() {
        unit_obj.obj.is_sick = true
        reload()
        (table.controller as? HabitUnitEditController)?.update_unit_type()
    }

}
