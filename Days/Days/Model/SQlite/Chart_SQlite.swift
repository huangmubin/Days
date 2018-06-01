//
//  Chart.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

extension SQLite {
    
    class Chart: SQLiteProtocol {
        
        // MARK: - Protocol
        
        /** Init */
        required init() {}
        
        /** table name */
        static var table: String = "Chart_SQlite"
        
        /** id */
        var id: Int = 0
        
        // MARK: - Values
        
        // MARK: Info
        
        /** 所属 Habit Id */
        var belong: Int = 0
        
        /**  */
        var name: String = ""
        
        /**  */
        var note: String = ""
        
        /** 目标，时间：秒。次数：次。 */
        var goal: Int = 0
        
        // MARK: Type
        
        /** 时长类型。月：0。周：1。 */
        private var _range_type: Int = 0
        /** 时长类型是否是月份 */
        var is_month: Bool {
            get { return _range_type == 0 }
            set { _range_type = newValue ? 0 : 1 }
        }
        
        // MARK: - From
        
        /** 来自 */
        private var _from: Int = 0
        /** Habit 自己创建 */
        var is_habit: Bool {
            get { return _from == 0 }
            set { _from = newValue ? 0 : 1 }
        }
        
        
        // MARK: - Sort
        
        /** Sort */
        var card_sort: Int = 0
    }
    
}
