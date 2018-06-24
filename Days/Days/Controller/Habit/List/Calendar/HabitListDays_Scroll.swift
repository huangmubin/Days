//
//  HabitListCalendar_Scroll.swift
//  Days
//
//  Created by 黄穆斌 on 2018/6/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol HabitListDays_Scroll_Delegate: class {
    func dayScroll(update date: Date)
    func dayScroll(light date: Date) -> Bool
}

extension HabitListDays {
    
    /** Calendar Scroll View */
    class Scroll: ScrollView, UIScrollViewDelegate, CalendarViewDelegate {
        
        // MARK: - Views
        
        /** 12 Cells */
        let cells: [HabitListDays.Scroll.Cell] = {
            var cells = [Cell]()
            for i in 0 ..< 13 {
                let cell = Cell()
                cells.append(cell)
            }
            return cells
        }()
        
        /** Calendar */
        let view: CalendarView = {
            let view = CalendarView()
            view.can_bounds = false
            return view
        }()
        
        // MARK: - Values
        
        /***/
        weak var days_delegate: HabitListDays_Scroll_Delegate?
        
        /** Get the yyyy年MM月 date string with offset */
        func date(offset: Int) -> String {
            let date = view.date
            return Format.yyyy年MM月.string(
                from: date.advance(.month, offset)
            )
        }
        
        // MARK: - Deploy
        
        override func view_deploy() {
            super.view_deploy()
            delegate = self
            showsVerticalScrollIndicator = false
            
            // Cells
            cells.forEach({ self.addSubview($0) })
            
            // Calendar
            view.delegate = self
            addSubview(view.collect)
        }
        
        // MARK: - Bounds
        
        override func view_bounds() {
            super.view_bounds()
            contentSize = CGSize(
                width: bounds.width,
                height: bounds.height * CGFloat(cells.count)
            )
            contentOffset = CGPoint(
                x: 0,
                y: bounds.height * CGFloat(cells.count / 2)
            )
            
            // Cells
            for (i, cell) in cells.enumerated() {
                cell.date.text = date(
                    offset: i - (cells.count / 2)
                )
                cell.frame = CGRect(
                    x: 0,
                    y: CGFloat(i) * bounds.height,
                    width: bounds.width,
                    height: bounds.height
                )
            }
            
            // Calendar
            view.collect.frame = CGRect(
                x: 0,
                y: CGFloat(cells.count / 2) * bounds.height,
                width: bounds.width,
                height: bounds.height
            )
        }
        
        // MARK: - UIScrollViewDelegate
        
        /** Hidden calendar */
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            if view.collect.alpha != 0 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.collect.alpha = 0
                })
            }
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                scrollViewDidEndDecelerating(scrollView)
            }
        }
        
        /**
         1. update the date and offset the subviews.
         2. show the calendar
         */
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let index = Int((scrollView.contentOffset.y + scrollView.bounds.height / 2) / scrollView.bounds.height)
            let offset = CGFloat(index) * bounds.height
            let date = view.date.advance(.month, index - (cells.count / 2))
            UIView.animate(withDuration: 0.5, animations: {
                self.contentOffset.y = offset
            }, completion: { _ in
                self.view.date = date
                self.view.collect.alpha = 0
                self.view_bounds()
                self.days_delegate?.dayScroll(update: date)
                
                // 2
                self.view.collect.reloadData()
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.collect.alpha = 1
                })
            })
        }
        
        // MARK: - CalendarViewDelegate
        
        func calendar(view: CalendarView, update date: Date) {
            days_delegate?.dayScroll(update: date)
        }
        
        func calendar(view: CalendarView, update cell: CalendarView.Collection.Cell, date: Date, index: IndexPath) {
            if days_delegate?.dayScroll(light: date) == true {
                if date.month == view.date.month {
                    cell.back.backgroundColor = Color.gray.dark
                    cell.info.textColor = Color.white
                    if date.day == view.date.day {
                        cell.flag.backgroundColor = Color.white
                    } else {
                        cell.flag.backgroundColor = cell.back.backgroundColor
                    }
                }
            }
        }
        
    }
    
}

extension HabitListDays.Scroll {
    
    // MARK: - Scroll Cell
    
    /** The HabitListDays Scroll's Cell */
    class Cell: View {
        
        /** The label to show date */
        let date: UILabel = Views.Label.title("2018年10月")
        
        override func view_deploy() {
            super.view_deploy()
            addSubview(date)
            view_bounds()
        }
        
        override func view_bounds() {
            super.view_bounds()
            date.frame = bounds
        }
        
    }
    
}
