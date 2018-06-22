//
//  M_HabitListCalendar.swift
//  Days
//
//  Created by Myron on 2018/6/22.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

extension Model {
    
    class HabitListCalendar: Model {
        
        // MARK: - Caches
        
        /** cache */
        private var _habit: [Habit] = []
        private var _units: [Int: [HabitUnit]] = [:]
        
        // MARK: - Reload
        
        func reload() {
            _habit = SQLite.Habit.find().map({ Habit($0) })
            _units.removeAll()
        }
        
        func reload(date: Date) {
            func habit(id: Int) -> Habit {
                return _habit.find(condition: { $0.obj.id == id })!
            }
            
            let start = date.first(.month).date - 1
            let days  = date.days(.month)
            let end   = date.first(.month).advance(.day, days).date + 1
            let units = SQLite.HabitUnit.find(
                where: "_date > \(start) and _date < \(end)")
                .sorted(by: { $0.start < $1.start })
                .map({ HabitUnit(habit(id: $0.belong), $0) })
            
            for i in start + 1 ..< start + days + 1 {
                _units[i] = []
            }
            
            var unit_date: Int = 0
            var unit_objs: [HabitUnit] = []
            for unit in units {
                if unit.obj.date != unit_date {
                    _units[unit_date] = unit_objs
                    unit_objs.removeAll()
                    unit_date = unit.obj.date
                }
                unit_objs.append(unit)
            }
            _units[unit_date] = unit_objs
        }
        
        // MARK: - Gets
        
        /** 按日期获取数据 */
        func unit(_ date: Int) -> [HabitUnit] {
            if _units[date] == nil {
                reload(date: Date(date))
            }
            return _units[date]!
        }
        
        /** 按上午，下午，晚上区分 */
        func unit(time date: Int) -> [[HabitUnit]] {
            var values: [[HabitUnit]] = [[],[],[]]
            unit(date).forEach({
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
    
}
