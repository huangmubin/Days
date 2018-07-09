//
//  HabitBoothCalendarCard.swift
//  Days
//
//  Created by Myron on 2018/5/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitBoothCalendarCard: CardCalendarView {
    
    override func view_deploy() {
        super.view_deploy()
        space_edge.bottom = 0
    }
    
    override func reload() {
        super.reload()
        collect.reloadData()
    }
    
    override func cardCalendar(view: CardCalendarView, update date: Date) {
        app.date = date
    }
    
    override func cardCalendar(view: CardCalendarView, is_done date: Date) -> Bool {
        return habit.units(date: date.date).count > 0
    }
    
    override func cardCalendar(view: CardCalendarView, is_sick date: Date) -> Bool {
        return habit.units(date: date.date).contains(where: { $0.obj.is_sick })
    }
    
}
