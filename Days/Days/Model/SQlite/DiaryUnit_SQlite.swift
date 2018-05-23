//
//  DiaryUnit_SQlite.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

extension SQLite {
    
    class DiaryUnit: SQLiteProtocol {
        
        // MARK: - Protocol
        
        /** Init */
        required init() {}
        
        /** table name */
        static var table: String = "DiaryUnit_SQlite"
        
        /** id */
        var id: Int = 0
        
        // MARK: - Values
        
        // MARK: Info
        
        /** 所属 Diary Id */
        var belong: Int = 0
        
        /** 日记内容 */
        var note: String = ""
        
        // MARK: Time
        
        /** 时间 */
        private var _date: Int = 0
        
        /** 开始时间，如果是次数则为创建时间 */
        var date: Date {
            get { return Date(time: _date) }
            set { _date = newValue.time1970 }
        }
        
        
    }
    
}
