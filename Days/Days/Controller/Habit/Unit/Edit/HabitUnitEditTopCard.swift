//
//  HabitUnitEditTopCard.swift
//  Days
//
//  Created by Myron on 2018/5/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitEditTopCard: CardTopView {

    override func reload() {
        super.reload()
        title.text = "打卡"
        subtitle.text = unit_obj.habit.obj.name
        view_bounds()
    }
    
    override func right_action(_ sender: UIButton) {
        if unit_obj.obj.id == 0 {
            table.vc?.toSuperController(object: [Key.Habit.Unit.append: unit_obj])
        } else {
            table.vc?.toSuperController(object: [Key.Habit.Unit.update: unit_obj])
        }
        table.controller?.dismiss(animated: true, completion: nil)
    }
    
}
