//
//  HabitUnitEditCalendarCard.swift
//  Days
//
//  Created by Myron on 2018/5/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitEditCalendarCard: CardCalendarView {
    
    override func reload() {
        super.reload()
        update(date: unit_obj.obj.start)
        if unit_obj.obj.id == 0 {
            date_button.isEnabled = true
            switch_button.isHidden = false
        } else {
            date_button.isEnabled = false
            switch_button.isHidden = true
        }
    }
    
    override func view_deploy() {
        super.view_deploy()
        space_edge.bottom = 0
    }
    
    override func cardCalendar(view: CardCalendarView, update date: Date) {
        unit_obj.habit.date = date
    }
    
    override func cardCalendar(view: CardCalendarView, is_done date: Date) -> Bool {
        return false
    }
    
    override func cardCalendar(view: CardCalendarView, is_sick date: Date) -> Bool {
        return false
    }
    
}
