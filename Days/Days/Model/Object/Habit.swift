//
//  Habit.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class Habit {
    
    // MARK: - Init
    
    let obj: SQLite.Habit
    
    init() {
        self.obj = SQLite.Habit()
    }
    
    init(_ obj: SQLite.Habit) {
        self.obj = obj
    }
    
    // MARK: - UI
    
    /** UIImage */
    func image() -> UIImage {
        return Resource.image(obj.image, obj.color)
    }
    
    /** Color */
    var color: UIColor {
        return UIColor(obj.color)
    }
    
    // MARK: - Units
    
    private var _units: [Int: [HabitUnit]] = [:]
    var dates: [Int] = []
    
    /** reload dates */
    func dates_reload() {
        dates.removeAll(keepingCapacity: true)
        SQLite.default.find(
            sql: "select distinct date from \(SQLite.HabitUnit.table) where belong = \(obj.id);",
            default: 0,
            datas: { dates.append($0) }
        )
    }
    
    /** Get [HabitUnit] in date */
    func units(date: Int) -> [HabitUnit] {
        if let objs = _units[date] {
            return objs
        } else {
            let objs = SQLite.HabitUnit.find(
                    where: "belong = \(obj.id) and _date = \(date)"
                ).map({ HabitUnit(self, $0) })
            _units[date] = objs
            return objs
        }
    }
    
}
