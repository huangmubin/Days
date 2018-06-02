//
//  CardBaseView.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol HabitObjectController {
    var habit: Habit! { get set }
}
protocol HabitUnitObjectController {
    var unit: HabitUnit! { get set }
}

class CardBaseView: CardView, KeyboardDelegate, ConfirmDelegate {

    /** The new_id */
    static var new_id: Int {
        let id = UserDefaults.standard.integer(forKey: "CardBaseView_Sort")
        UserDefaults.standard.set(id + 2, forKey: "CardBaseView_Sort")
        return id + 2
    }
    
    var habit: Habit {
        if let obj = table.controller as? HabitUnitObjectController {
            return obj.unit.habit
        }
        return (table.controller as! HabitObjectController).habit
    }
    var unit_obj: HabitUnit {
        return (table.controller as! HabitUnitObjectController).unit
    }
    
    func keyboard(_ board: Keyboard) -> String? {
        return nil
    }
    
    func confirm(_ view: Confirm) {
        
    }
    
    override func view_deploy() {
        super.view_deploy()
        space_edge.bottom = 20
    }
    
}
