//
//  EventUnit.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

class EventUnit {
    
    // MARK: - Init
    
    let obj: SQLite.EventUnit
    
    weak var event: Event!
    
    init(_ event: Event) {
        self.event = event
        self.obj   = SQLite.EventUnit()
        self.obj.belong = event.obj.id
    }
    
    init(_ event: Event, _ obj: SQLite.EventUnit) {
        self.event = event
        self.obj   = obj
    }
    
}
