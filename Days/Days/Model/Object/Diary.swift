//
//  Diary.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

class Diary {
    
    // MARK: - Init
    
    let obj: SQLite.Diary
    
    weak var habit: Habit!
    
    init(_ habit: Habit) {
        self.habit = habit
        self.obj   = SQLite.Diary()
        
        self.obj.belong = habit.obj.id
    }
    
    init(_ habit: Habit, _ obj: SQLite.Diary) {
        self.habit = habit
        self.obj = obj
    }
    
    // MARK: - Units
    
    /** Units */
    private var _units: [Int: DiaryUnit] = [:]
    
    /** 输出日记单元 */
    func units(date: Int) -> DiaryUnit {
        if let objs = _units[date] {
            return objs
        }
        if let objs = SQLite.DiaryUnit.find(
            where: "belong = \(obj.id) and date = \(date)"
            ).map({ DiaryUnit(self, $0) }).first {
            _units[date] = objs
            return objs
        } else {
            let objs = DiaryUnit(self)
            objs.obj.date = Date(date)
            objs.obj.id = SQLite.DiaryUnit.new_id
            objs.obj.belong = obj.id
            objs.obj.insert()
            _units[date] = objs
            return objs
        }
    }
    
    // MARK: - Delete
    
    func delete() {
        let sql = "delete from \(SQLite.DiaryUnit.table) where belong = \(obj.id);"
        let _ = SQLite.default.execute(sql: sql)
        obj.delete()
    }
    
}
