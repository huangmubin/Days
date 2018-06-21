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
        if let obj = SQLite.Diary.find(where: "belong = \(obj.id)").map({ Diary(self, $0) }).first {
            diary = obj
        }
        self.charts = SQLite.Chart.find(where: "belong = \(obj.id)").map({ Chart(self, $0) })
        self.events = SQLite.Event.find(where: "belong = \(obj.id)").map({ Event(self, $0) })
        if let chart = self.charts.find(condition: { $0.obj.is_habit }) {
            chart.obj.goal = obj.frequency
        }
    }
    
    // MARK: - Date
    
    /** Date */
    var date: Date = Date()
    
    // MARK: - UI
    
    /** UIImage */
    func image() -> UIImage {
        return Resource.image(obj.image, obj.color)
    }
    
    /** UIImage */
    func image(color: UIColor) -> UIImage {
        return Resource.image(obj.image, color.number())
    }
    
    /** Color */
    var color: UIColor {
        return UIColor(obj.color)
    }
    
    // MARK: - Animation Flag
    
    /** open animation */
    var is_animation: Bool = false
    
    // MARK: - Units
    
    private var _units: [Int: [HabitUnit]] = [:]
    var dates: [Int] = []
    
    /** reload dates */
    func dates_reload() {
        dates.removeAll(keepingCapacity: true)
        SQLite.default.find(
            sql: "select distinct _date from \(SQLite.HabitUnit.table) where belong = \(obj.id);",
            default: 0,
            datas: { dates.append($0) }
        )
        dates.sort()
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
    
    /** Remove the count in date */
    func units(remove date: Int) {
        var objs = units(date: date)
        var time = obj.space
        while time > 0 && objs.count > 0 {
            let unit = objs.removeLast()
            if unit.obj.length > time {
                unit.obj.length -= time
                unit.obj.update()
                objs.append(unit)
                time = 0
            } else {
                time -= unit.obj.length
                unit.obj.delete()
            }
        }
        _units[date] = objs
    }
    
    /** Insert unit */
    func units(insert date: Int, unit: HabitUnit) {
        let objs = units(date: date)
        _units[date] = objs + [unit]
        //chart.units(update: date)
    }
    
    /** Remove unit at index. if the date is empty, return true, else false */
    func units(remove index: IndexPath) -> Bool {
        let date = dates[index.section]
        var objs = units(date: date)
        let obj = objs.remove(at: index.row)
        obj.obj.delete()
        _units[date] = objs
        //chart.units(update: date)
        
        if objs.count == 0 {
            dates.remove(at: index.section)
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Chart
    
    /** Chart */
    var chart: Chart { return charts.find(condition: { $0.obj.is_habit })! }
    
    /** 图表数据 */
    var charts: [Chart] = []
    
    /**  */
    func chart_create() {
        //let chart = Chart(self)
        //chart.obj.id = SQLite.Chart.new_id
        //chart.obj.belong = obj.id
        //chart.obj.goal = obj.frequency
        //chart.obj.name = "图表"
        //chart.obj.note = "日常记录分析"
        //chart.obj.card_sort = CardBaseView.new_id
        //chart.obj.insert()
        //charts.insert(chart, at: 0)
    }
    
    // MARK: - Event
    
    /** Event */
    var events: [Event] = []
    
    /**  */
    func event_create() {
        //let event = Event(self)
        //event.obj.id = SQLite.Event.new_id
        //event.obj.belong = obj.id
        //event.obj.name   = "里程碑"
        //event.obj.card_sort = CardBaseView.new_id
        //event.obj.insert()
        //events.insert(event, at: 0)
    }
    
    // MARK: - Diary
    
    /** Diary */
    var diary: Diary?
    
    /***/
    func diary_create() {
        //let diary = Diary(self)
        //diary.obj.id = SQLite.Diary.new_id
        //diary.obj.belong = self.obj.id
        //diary.obj.name = "日记"
        //diary.obj.card_sort = CardBaseView.new_id
        //diary.obj.insert()
        //self.diary = diary
    }
    
    // MARK: - Delete
    
    func delete() {
        let sql = "delete from \(SQLite.HabitUnit.table) where belong = \(obj.id);"
        let _ = SQLite.default.execut(sql: sql)
        charts.forEach({ $0.delete() })
        events.forEach({ $0.delete() })
        diary?.delete()
        obj.delete()
    }
}
