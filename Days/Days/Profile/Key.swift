//
//  Key.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

class Key {
    
    static let root_storyboard = "key_root_init_storyboard"
    
    class Habit {
        static let append = "key_habit_append"
        static let update = "key_habit_update"
        static let delete = "key_habit_delete"
        
        class Unit {
            static let append = "key_habit_unit_append"
            static let update = "key_habit_unit_update"
            static let delete = "key_habit_unit_delete"
        }
    }
    
    class Event {
        static let append = "key_event_append"
        static let update = "key_event_update"
        static let delete = "key_event_delete"
        
        class Unit {
            static let append = "key_event_unit_append"
            static let update = "key_event_unit_update"
            static let delete = "key_event_unit_delete"
        }
    }
    
    class Chart {
        static let append = "key_chart_append"
        static let update = "key_chart_update"
        static let delete = "key_chart_delete"
        
        class Unit {
            static let append = "key_chart_unit_append"
            static let update = "key_chart_unit_update"
            static let delete = "key_chart_unit_delete"
        }
    }
    
    class Diary {
        static let append = "key_diary_append"
        static let update = "key_diary_update"
        static let delete = "key_diary_delete"
        
        class Unit {
            static let append = "key_diary_unit_append"
            static let update = "key_diary_unit_update"
            static let delete = "key_diary_unit_delete"
        }
    }
    
    // MARK: - Timer
    
    class Timer {
        static let start = "key_timer_start"
        static let unit  = "key_timer_unit"
        static let space = "key_timer_space"
    }
    
}
