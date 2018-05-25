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

class CardBaseView: CardView, KeyboardDelegate {

    var habit: Habit {
        return (table.controller as! HabitObjectController).habit
    }

    func keyboard(_ board: Keyboard) -> String? {
        return nil
    }
    
}
