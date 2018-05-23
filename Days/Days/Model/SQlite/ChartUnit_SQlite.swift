//
//  ChartUnit_SQlite.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

extension SQLite {
    
    class ChartUnit: SQLiteProtocol {
        
        // MARK: - Protocol
        
        /** Init */
        required init() {}
        
        /** table name */
        static var table: String = "ChartUnit_SQlite"
        
        /** id */
        var id: Int = 0
        
        // MARK: - Values
        
        // MARK: Info
        
        /** 所属 Chart Id */
        var belong: Int = 0
        
        /** 所属的日期 */
        var date: Int = 0
        
        /** 长度，时间：秒。次数：次。 */
        var length: Int = 0
        
    }
    
}
