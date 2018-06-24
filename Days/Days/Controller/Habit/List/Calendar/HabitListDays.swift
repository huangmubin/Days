//
//  HabitListCalendar.swift
//  Days
//
//  Created by Myron on 2018/6/21.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol HabitListDays_Delegate: class {
    func habitListDays(update date: Date)
}

// MARK: - HabitListCalendar

class HabitListDays: View, HabitListDays_Scroll_Delegate {
    
    /**  */
    weak var controller_link: HabitListController?
    
    /**  */
    weak var delegate: HabitListDays_Delegate?
    
    // MARK: - Values
    
    /**  */
    let model: Model.HabitListCalendar = Model.HabitListCalendar()
    
    /**  */
    var is_showing: Bool { return alpha > 0 }
    
    /**  */
    var date: Date {
        return calendar.view.date
    }
    
    // MARK: - Action
    
    /** */
    func reload() {
        model.reload()
        calendar.view.collect.reloadData()
        table.units = model.unit(time: date.date)
        table.reload()
    }
    
    func clear() {
        model.reload()
        table.units.removeAll()
    }
    
    // MARK: - SubView
    
    /**  */
    let calendar: HabitListDays.Scroll = Scroll()
    
    /**  */
    let table: HabitListDays.Table = Table()
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        // Model
        
        model.reload()
        
        // MASK
        
        self.mask = UIView()
        self.frame = bounds
        self.mask?.backgroundColor = UIColor.white
        
        // Calendar
        addSubview(calendar.view.week)
        addSubview(calendar)
        calendar.days_delegate = self
        
        // Table
        addSubview(table)
        table.units = model.unit(time: date.date)
        table.reload()
    }
    
    // MARK: - Bounds
    
    override func view_bounds() {
        super.view_bounds()
        self.mask?.frame = bounds
        
        let space: CGFloat = 20
        let w = (bounds.width - space - space) / 7
        
        // Calendar
        
        calendar.view.week.frame = CGRect(
            x: space, y: 0,
            width: w * 7,
            height: w
        )
        
        calendar.frame = CGRect(
            x: space, y: w,
            width: w * 7,
            height: w * 6
        )
        
        // Table
        
        table.frame = CGRect(
            x: space, y: calendar.frame.maxY,
            width: calendar.frame.width,
            height: bounds.height - calendar.frame.maxY
        )
    }
    
    // MARK: - Show Animation
    
    /** Open or close the view */
    func animation(show: Bool) {
        if show { // Open self
            var mask_frame = CGRect(
                x: 0, y: 0,
                width: bounds.width,
                height: 0
            )
            mask?.frame = mask_frame
            mask_frame.size.height = bounds.height
            UIView.animate(withDuration: 0.5, animations: {
                self.mask?.frame = mask_frame
                self.alpha = 1
            })
        } else { // Close self
            let mask_frame = CGRect(
                x: 0, y: 0,
                width: bounds.width,
                height: 0
            )
            UIView.animate(withDuration: 0.5, animations: {
                self.mask?.frame = mask_frame
                self.alpha = 0
            })
        }
    }
    
    // MARK: - HabitListDays_Scroll_Delegate
    
    func dayScroll(update date: Date) {
        delegate?.habitListDays(update: date)
        table.units = model.unit(time: date.date)
        table.reload()
    }
    
    func dayScroll(light date: Date) -> Bool {
        return model.unit(date.date).count > 0
    }
    
}
