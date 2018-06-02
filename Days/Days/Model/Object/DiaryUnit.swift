//
//  DiaryUnit.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

class DiaryUnit {
    
    // MARK: - Init
    
    let obj: SQLite.DiaryUnit
    
    weak var diary: Diary!
    
    init(_ diary: Diary) {
        self.diary = diary
        
        self.obj   = SQLite.DiaryUnit()
        self.obj.belong = diary.obj.id
    }
    
    init(_ chart: Diary, _ obj: SQLite.DiaryUnit) {
        self.diary = chart
        self.obj   = obj
    }
    
}
