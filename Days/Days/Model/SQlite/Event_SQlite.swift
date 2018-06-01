//
//  Event_SQlite.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

extension SQLite {
    
    class Event: SQLiteProtocol {
        
        // MARK: - Protocol
        
        /** Init */
        required init() {}
        
        /** table name */
        static var table: String = "Event_SQlite"
        
        /** id */
        var id: Int = 0
        
        // MARK: - Values
        
        // MARK: Info
        
        /** 所属 Habit Id */
        var belong: Int = 0
        
        /**  */
        var name: String = "里程碑"
        
        /**  */
        var note: String = ""
        
        // MARK: - Sort
        
        /** Sort */
        var card_sort: Int = 0
        
    }
    
}
