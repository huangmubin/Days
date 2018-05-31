//
//  Chart.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

class Chart {
    
    // MARK: - Init
    
    let obj: SQLite.Chart
    
    weak var habit: Habit!
    
    init(_ habit: Habit) {
        self.habit = habit
        self.obj   = SQLite.Chart()
        
        self.obj.belong = habit.obj.id
        self.obj.goal   = habit.obj.frequency
    }
    
    init(_ habit: Habit, _ obj: SQLite.Chart) {
        self.habit = habit
        self.obj = obj
    }
    
    // MARK: - Date
    
    /**  */
    var date: Date = Date()
    
    // MARK: - Units
    
    private var _units: [Int: ChartUnit] = [:]
    
    /**  */
    func units(date: Int) -> ChartUnit {
        if let objs = _units[date] {
            return objs
        }
        if obj.is_habit {
            let objs = ChartUnit(self)
            objs.obj.belong = obj.id
            objs.obj.date = date
            objs.obj.length = habit.units(date: date).count(value: { $0.obj.length })
            _units[date] = objs
            return objs
        } else {
            if let objs = SQLite.ChartUnit.find(
                where: "belong = \(obj.id) and date = \(date)"
                ).map({ ChartUnit(self, $0) }).first {
                _units[date] = objs
                return objs
            } else {
                let objs = ChartUnit(self)
                objs.obj.date = date
                objs.obj.id = SQLite.ChartUnit.new_id
                objs.obj.insert()
                _units[date] = objs
                return objs
            }
        }
    }
    
    /** Only habit chart */
    func units(update date: Int) {
        if let objs = _units[date] {
            if obj.is_habit {
                objs.obj.length = habit.units(date: date).count(value: { $0.obj.length })
            }
        }
    }
    
    
}
