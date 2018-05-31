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
        //self.chart_create()
        self.charts = SQLite.Chart.find(where: "belong = \(obj.id)").map({ Chart(self, $0) })
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
    }
    
    // MARK: - Chart
    
    /** Chart */
    var chart: Chart { return charts.find(condition: { $0.obj.is_habit })! }
    
    /** 图表数据 */
    var charts: [Chart] = []
    
    /**  */
    func chart_create() {
        let chart = Chart(self)
        chart.obj.belong = obj.id
        chart.obj.goal = obj.frequency
        chart.obj.name = "图表"
        chart.obj.note = "日常记录分析"
        chart.obj.insert()
        charts.insert(chart, at: 0)
    }
    
}
