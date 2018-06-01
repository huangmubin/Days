//
//  EventUnit_SQlite.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

extension SQLite {
    
    class EventUnit: SQLiteProtocol {
        
        // MARK: - Protocol
        
        /** Init */
        required init() {}
        
        /** table name */
        static var table: String = "EventUnit_SQlite"
        
        /** id */
        var id: Int = 0
        
        // MARK: - Values
        
        // MARK: Info
        
        /** 所属 Event Id */
        var belong: Int = 0
        
        /**  */
        var name: String = ""
        
        /**  */
        var note: String = ""
        
        // MARK: Time
        
        /** 到期日期，如果无则是创建日期 */
        var date: Int = Date().date
        
        // MARK: - Sort
        
        /** 等级 */
        var level: Int = 0
        
        /** 顺序 */
        var sort: Int = 0
        
        // MARK: - Complete
        
        /** 是否已经完成 */
        private var _done: Int = 0
        /** 是否已经完成 */
        var is_done: Bool {
            get { return _done == 1 }
            set { _done = newValue ? 1 : 0 }
        }
        
    }
    
}
