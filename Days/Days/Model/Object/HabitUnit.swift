//
//  HabitUnit.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

class HabitUnit {
    
    // MARK: - Init
    
    let obj: SQLite.HabitUnit
    
    weak var habit: Habit!
    
    init(_ habit: Habit) {
        self.habit = habit
        self.obj   = SQLite.HabitUnit()
        
        self.obj.belong = habit.obj.id
        self.obj.start  = Date().advance(Double(-habit.obj.frequency))
        self.obj.length = habit.obj.space
    }
    
    init(_ habit: Habit, _ obj: SQLite.HabitUnit) {
        self.habit = habit
        self.obj = obj
    }
    
    // MARK: - Type
    
    /** is time or count */
    var is_time: Bool { return habit.obj.is_time }
    
}
