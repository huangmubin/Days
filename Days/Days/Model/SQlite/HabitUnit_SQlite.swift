//
//  HabitUnit_SQlite.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

extension SQLite {
    
    class HabitUnit: SQLiteProtocol {
        
        // MARK: - Protocol
        
        /** Init */
        required init() {}
        
        /** table name */
        static var table: String = "HabitUnit_SQlite"
        
        /** id */
        var id: Int = 0
        
        // MARK: - Values
        
        // MARK: Info
        
        /** 所属 Habit Id */
        var belong: Int = 0
        
        /**  */
        var note: String = ""
        
        // MARK: Time
        
        /** 日期 20180101，只用于方便搜索 */
        private var _date: Int = 0
        /** 开始时间 */
        private var _start: Int = 0
        /** 记录长度。时间：秒。次数：次。 */
        var length: Int = 0
        
        /** 开始时间，如果是次数则为创建时间 */
        var start: Date {
            get { return Date(time: _start) }
            set {
                _start = newValue.time1970
                _date = newValue.date
            }
        }
        /** 结束时间 */
        var end: Date { return start.advance(Double(length)) }
        var date: Int { return _date }
        
        // MARK: Type
        
        /** 类型记录，0: 正常打卡; 1: 请假打卡; */
        private var _type: Int = 0
        /** 是否是请假 */
        var is_sick: Bool {
            get { return _type == 1 }
            set { _type = newValue ? 1 : 0 }
        }
        
    }
    
}
