//
//  Habit_SQlite.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

extension SQLite {
    
    class Habit: SQLiteProtocol {
        
        // MARK: - Protocol
        
        /** Init */
        required init() {}
        
        /** table name */
        static var table: String = "Habit_SQlite"
        
        /** id */
        var id: Int = 0
        
        // MARK: - Values
        
        // MARK: Info
        
        /**  */
        var name: String = ""
        /**  */
        var note: String = ""
        
        // MARK: Time
        
        /** 习惯创建时间 */
        var start: Int = Date().time1970
        /** 习惯目标。时间：秒。类型为次数：次。默认 1000 小时。 */
        var goal: Int = 3600000
        /** 每日频率。时间：秒。次数：次。默认 10 分钟 */
        var frequency: Int = 600
        /** 每次打卡默认的时长 */
        var space: Int = 60
        
        // MARK: Sort
        
        /** Sort */
        var sort: Int = 0
        
        // MARK: Type
        
        /** 统计类型。0: 时间; 1: 次数 */
        private var _type: Int = 0
        /** 统计类型是否是时间，还是次数。 */
        var is_time: Bool {
            set { _type = (newValue ?  0 : 1) }
            get { return _type == 0 }
        }
        /** 获取统计类型的单位，时间为 nil */
        var type: String? {
            set {
                if let value = newValue {
                    var types = (UserDefaults.standard.array(forKey: "habit_sqlite_type_list") as? [String]) ?? ["时","次","米","里"]
                    if !types.contains(value) {
                        types.append(value)
                        UserDefaults.standard.set(types, forKey: "habit_sqlite_type_list")
                    }
                    _type = types.index(of: value)!
                } else {
                    _type = 0
                }
            }
            get {
                if _type == 0 {
                    return nil
                } else {
                    let types = (UserDefaults.standard.array(forKey: "habit_sqlite_type_list") as? [String]) ?? ["时","次","米","里"]
                    return types[_type]
                }
            }
        }
        
        // MARK: - State
        
        /** 习惯状态。0: 进行中; 1: 归档; */
        private var _state: Int = 0
        /** 习惯状态是否是进行中，还是归档 */
        var is_runing: Bool {
            set { _state = (newValue ?  0 : 1) }
            get { return _state == 0 }
        }
        
        // MARK: - UI
        
        /** 图标名称 */
        var image: String = "habits_book_01"
        
        /** 颜色 */
        var color: Int = 0xF16D7A
        //var color: Int = 0
        
    }
    
}
