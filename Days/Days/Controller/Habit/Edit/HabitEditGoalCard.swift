//
//  HabitEditGoalCard.swift
//  Days
//
//  Created by Myron on 2018/5/25.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditGoalCard: CardStandardEditView {
    
    // MARK: - View Deploy
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "目标"
        info_edit.text = "修改单位"
    }
    
    // MARK: - View Reload
    
    override func reload() {
        super.reload()
        if habit.obj.is_time {
            if habit.obj.goal % 3600 == 0 {
                info.text = "\(habit.obj.goal / 3600)"
            } else {
                info.text = String(format: "%.1f", Double(habit.obj.goal) / 3600)
            }
            info_sub.text = "小时"
        } else {
            info.text = habit.obj.goal.description
            info_sub.text = habit.obj.type!
        }
        
        view_bounds()
    }
    
    // MARK: - Keyboard
    
    override func keyboard(_ board: Keyboard) -> String? {
        if board.id == "normal" {
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
        } else {
            guard board.text.text.count < 3 else {
                return "单位不易过长"
            }
            switch board.text.text {
            case "": break
            case "时间", "小时", "分钟", "秒", "分", "时", "时辰", "时长":
                if !habit.obj.is_time {
                    habit.obj.goal *= 3600
                    habit.obj.is_time = true
                }
            case "次数", "次":
                if habit.obj.is_time {
                    habit.obj.goal /= 3600
                    habit.obj.is_time = false
                }
            default:
                if habit.obj.is_time {
                    habit.obj.goal /= 3600
                }
                habit.obj.type = board.text.text
            }
        }
        reload()
        return nil
    }
    
    override func normal_keyboard(_ board: Keyboard) {
        board.text.keyboardType = .numberPad
        board.update(title: habit.obj.is_time ? "小时" : "次数")
        board.update(text: info.text ?? "")
    }
    
    override func edit_keyboard(_ board: Keyboard) {
        board.update(title: "时间/次数/自定义")
        board.update(text: habit.obj.type ?? "时间")
    }
    
}
/*
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
            timer.backgroundColor = habit.color
            count.setTitleColor(Color.dark, for: .normal)
            count.backgroundColor = Color.gray.light
            
            if habit.obj.goal % 3600 == 0 {
                goal.text = "\(habit.obj.goal / 3600)"
            } else {
                goal.text = String(format: "%.1f", Double(habit.obj.goal) / 3600)
            }
            unit.text = "小时"
        } else {
            timer.setTitleColor(Color.dark, for: .normal)
            timer.backgroundColor = Color.gray.light
            count.setTitleColor(Color.white, for: .normal)
            count.backgroundColor = habit.color
            
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
    
    let timer: UIButton = Views.Button.normal(title: "计时")
    let count: UIButton = Views.Button.normal(title: "计次")
    let goal_button: UIButton = Views.Button.normal(title: "")
    
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
    
    let goal: UILabel = Views.Label.normal("")
    let unit: UILabel = Views.Label.hint("小时")
    
}
*/
