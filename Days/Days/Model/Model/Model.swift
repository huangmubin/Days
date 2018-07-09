//
//  Model.swift
//  Days
//
//  Created by Myron on 2018/6/22.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

/** App 数据 */
var app: Model = Model()
class Model {
    
    // MARK: - Date
    
    var date: Date = Date()
    
    func date(decrease: Int) -> Date {
        return date.first(.day).advance(TimeInterval(Date().time - decrease))
    }
    
    // MARK: - Habits
    
    var habits: [Habit] = []
    
    func reload(habit animate: Bool) {
        habits = SQLite.Habit.find().sorted(by: {
            $0.sort < $1.sort
        }).map({
            let obj = Habit($0)
            obj.is_animation = animate
            return obj
        })
    }
    
    func append(habit obj: Habit) {
        obj.obj.id = SQLite.Habit.new_id
        obj.obj.sort = obj.obj.id
        obj.obj.insert()
        habits.append(obj)
    }
    
    func delete(habit obj: Habit) {
        if let row = habits.index(where: { $0 === obj }) {
            habits.remove(at: row)
        }
        obj.delete()
    }
    
    // MARK: - Habit List Days Unit
    
    func units(date: Int) -> [[HabitUnit]] {
        var values: [[HabitUnit]] = [[],[],[]]
        habits.flatMap({ $0.units(date: date) })
            .sorted(by: { $0.obj.start < $1.obj.start })
            .forEach({
            switch $0.obj.start.time {
            case 14400 ..< 43200: // 04:00 - 12:00
                values[0].append($0)
            case 43200 ..< 72000: // 12:00 - 20:00
                values[1].append($0)
            default: // 20:00 - 04:00
                values[2].append($0)
            }
        })
        return values
    }
    
}
