//
//  HabitEditTopCard.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditTopCard: CardTopView {
    
    override func view_deploy() {
        super.view_deploy()
        space_edge.bottom = 0
    }
    
    override func reload() {
        super.reload()
        right.isHidden = true
        title.text = (habit.obj.id == 0 ? "新增习惯" : habit.obj.name)
    }
    
    override func left_action(_ sender: UIButton) {
        table.controller?.dismiss(animated: true, completion: nil)
    }
    
    override func right_action(_ sender: UIButton) {
        if habit.obj.id == 0 {
            table.vc?.toSuperController(object: [Key.Habit.append: habit])
        } else {
            table.vc?.toSuperController(object: [Key.Habit.update: habit])
        }
        table.controller?.dismiss(animated: true, completion: nil)
    }
    
    func update_button() {
        right.isHidden = habit.obj.name.isEmpty
    }
    
}
