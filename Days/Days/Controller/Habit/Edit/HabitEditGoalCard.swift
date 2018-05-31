//
//  HabitEditGoalCard.swift
//  Days
//
//  Created by Myron on 2018/5/25.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditGoalCard: CardStandardView {
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "目标"
        
        container.addSubview(timer)
        container.addSubview(count)
        container.addSubview(goal_button)
        container.addSubview(goal)
        container.addSubview(unit)
        
        timer.addTarget(self, action: #selector(timer_action), for: .touchUpInside)
        count.addTarget(self, action: #selector(count_action), for: .touchUpInside)
        goal_button.addTarget(self, action: #selector(goal_action), for: .touchUpInside)
        
        container.backgroundColor = Color.white
    }
    
    override func reload() {
        super.reload()
        if habit.obj.is_time {
            timer.setTitleColor(Color.white, for: .normal)
            timer.normal_color = habit.color
            count.setTitleColor(Color.dark, for: .normal)
            count.normal_color = Color.gray.light
            
            if habit.obj.goal % 3600 == 0 {
                goal.text = "\(habit.obj.goal / 3600)"
            } else {
                goal.text = String(format: "%.1f", Double(habit.obj.goal) / 3600)
            }
            unit.text = "小时"
        } else {
            timer.setTitleColor(Color.dark, for: .normal)
            timer.normal_color = Color.gray.light
            count.setTitleColor(Color.white, for: .normal)
            count.normal_color = habit.color
            
            goal.text = habit.obj.goal.description
            unit.text = "次"
        }
        
        goal.sizeToFit()
        unit.sizeToFit()
        update_goal()
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        timer.frame = CGRect(
            x: 0, y: 0,
            width: container.bounds.width / 2 - 10,
            height: (container.bounds.height - 20) / 2
        )
        count.frame = CGRect(
            x: timer.frame.maxX + 20, y: timer.frame.minY,
            width: timer.frame.width,
            height: timer.frame.height
        )
        goal_button.frame = CGRect(
            x: 0, y: timer.frame.maxY + 20,
            width: container.bounds.width,
            height: (container.bounds.height - 20) / 2
        )
        
        update_goal()
    }
    
    func update_goal() {
        goal.center = CGPoint(
            x: goal_button.center.x - unit.bounds.width / 2 - 4,
            y: goal_button.center.y
        )
        unit.center = CGPoint(
            x: goal_button.center.x + goal.bounds.width / 2 + 4,
            y: goal.center.y
        )
    }
    
    // MARK: - Buttons
    
    let timer: Button = {
        let button = Button(type: .custom)
        button.normal_color = Color.gray.light
        button.corner = 10
        button.titleLabel?.font = Font.text.b
        button.setTitle("计时", for: .normal)
        button.setTitleColor(Color.dark, for: .normal)
        return button
    }()
    
    let count: Button = {
        let button = Button()
        button.corner = 10
        button.normal_color = Color.gray.light
        button.titleLabel?.font = Font.text.b
        button.setTitle("计次", for: .normal)
        return button
    }()
    
    let goal_button: Button = {
        let button = Button()
        button.corner = 10
        button.normal_color = Color.gray.light
        button.titleLabel?.font = Font.title.s
        return button
    }()
    
    @objc func timer_action() {
        if !habit.obj.is_time {
            habit.obj.is_time = true
            habit.obj.goal *= 3600
            habit.obj.frequency *= 60
            habit.obj.space *= 60
            (table.controller as? HabitEditController)?.type_update()
            reload()
        }
    }
    
    @objc func count_action() {
        if habit.obj.is_time {
            habit.obj.is_time = false
            habit.obj.goal /= 3600
            habit.obj.frequency /= 60
            habit.obj.space /= 60
            (table.controller as? HabitEditController)?.type_update()
            reload()
        }
    }
    
    @objc func goal_action() {
        let board = Keyboard()
        board.text.keyboardType = .numberPad
        board.update(title: habit.obj.is_time ? "小时" : "次数")
        board.update(text: goal.text ?? "")
        board.delegate = self
        board.push()
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        guard let text = board.value as? String else {
            return "输入不合法"
        }
        guard let int = Int(text) else {
            return "输入不合法"
        }
        if habit.obj.is_time {
            habit.obj.goal = int * 3600
        } else {
            habit.obj.goal = int
        }
        reload()
        return nil
    }
    
    // MARK: - Labels
    
    let goal: UILabel = {
        let label = UILabel()
        label.font = Font.text.b
        label.textColor = Color.dark
        return label
    }()
    
    let unit: UILabel = {
        let label = UILabel()
        label.text = "小时"
        label.font = Font.text.s
        label.textColor = Color.gray.halftone
        return label
    }()
    
}
