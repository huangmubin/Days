//
//  Event.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

class Event {
    
    // MARK: - Init
    
    let obj: SQLite.Event
    
    weak var habit: Habit!
    
    init(_ habit: Habit) {
        self.habit = habit
        self.obj   = SQLite.Event()
        
        self.obj.belong = habit.obj.id
    }
    
    init(_ habit: Habit, _ obj: SQLite.Event) {
        self.habit = habit
        self.obj = obj
    }
    
    // MARK: - Units
    
    /** Units */
    var units: [EventUnit] = []
    
    /**  */
    func units_update() {
        units = SQLite.EventUnit.find(where: "belong = \(obj.id)").map({ EventUnit(self, $0) }).compactMap({ $0.obj.is_done ? $0 : nil })
    }
    
    // MARK: - Delete
    
    func delete() {
        let sql = "delete from \(SQLite.EventUnit.table) where belong = \(obj.id);"
        let _ = SQLite.default.execut(sql: sql)
        obj.delete()
    }
}
