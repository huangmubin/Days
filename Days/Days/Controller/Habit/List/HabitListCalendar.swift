//
//  HabitListCalendar.swift
//  Days
//
//  Created by Myron on 2018/6/21.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

// MARK: - HabitListCalendar

class HabitListCalendar: View, CalendarViewDelegate {
    
    // MARK: - Lines
    
    /** HabitListController */
    weak var controller: HabitListController?
    
    let model: Model.HabitListCalendar = Model.HabitListCalendar()
    
    var date: Date {
        get { return controller?.date ?? Date() }
        set {
            controller?.date = newValue
            controller?.top.title.setTitle(Format.day_month(newValue), for: .normal)
        }
    }
    
    func reload() {
        calendar.date = date
        calendar.collect.reloadData()
        table.values = model.unit(time: date.date)
        table.reloadData()
    }
    
    // MARK: - Values
    
    /** 是否显示中 */
    var is_showing: Bool { return alpha > 0 }
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        model.reload()
        
        // MASK
        
        self.mask = UIView()
        self.frame = bounds
        self.mask?.backgroundColor = UIColor.white
        
        // Week
        
        addSubview(calendar.week)
        
        // Scroll
        
        addSubview(scroll)
        scroll.calendar = self
        calendar(show: 0)
        calendar.delegate = self
        
        // Table
        
        addSubview(table)
        table.values = model.unit(time: date.date)
    }
    
    // MARK: - Bounds
    
    override func view_bounds() {
        super.view_bounds()
        self.mask?.frame = bounds
        
        let space: CGFloat = 20
        let w = (bounds.width - space - space) / 7
        
        // Week
        
        calendar.week.frame = CGRect(
            x: space, y: 0,
            width: w * 7,
            height: w
        )
        
        // Scroll
        
        scroll.frame = CGRect(
            x: space, y: calendar.week.frame.maxY,
            width: w * 7,
            height: w * 6
        )
        
        calendar.collect.frame = CGRect(
            x: 0, y: 0,
            width: scroll.frame.width,
            height: scroll.frame.height
        )
        
        // Table
        
        table.frame = CGRect(
            x: space, y: scroll.frame.maxY,
            width: scroll.frame.width,
            height: frame.height - scroll.frame.maxY
        )
    }
    
    // MARK: - Show Animation
    
    /**  */
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
            }, completion: nil)
        } else { // Close self
            let mask_frame = CGRect(
                x: 0, y: 0,
                width: bounds.width,
                height: 0
            )
            UIView.animate(withDuration: 0.5, animations: {
                self.mask?.frame = mask_frame
                self.alpha = 0
            }, completion: nil)
        }
    }
    
    // MARK: - Scroll
    
    let scroll = HabitListCalendar.Scroll(frame: CGRect.zero)
    
    // MARK: - Calendar
    
    let calendar: CalendarView = {
        let view = CalendarView()
        view.can_bounds = false
        
        view.week.color = Color.gray.halftone
        view.week.font = Font.text.m
        view.week.update()
        return view
    }()
    
    func calendar(hidden time: TimeInterval) {
        if self.calendar.collect.alpha != 0 {
            UIView.animate(withDuration: time, animations: {
                self.calendar.collect.alpha = 0
            }, completion: nil)
        }
    }
    
    func calendar(show time: TimeInterval) {
        calendar.date = date
        calendar.collect.reloadData()
        calendar.collect.alpha = 0
        scroll.container.addSubview(calendar.collect)
        UIView.animate(withDuration: time, animations: {
            self.calendar.collect.alpha = 1
        }, completion: nil)
    }
    
    func calendar(view: CalendarView, update date: Date) {
        self.date = date
        table.values = model.unit(time: date.date)
        table.reloadData()
    }
    
    func calendar(view: CalendarView, update cell: CalendarView.Collection.Cell, index: IndexPath) {
        
    }
    
    // MARK: - Table
    
    let table: Table = Table(frame: CGRect.zero, style: UITableViewStyle.plain)
    
}

extension HabitListCalendar {
    
    class Scroll: ScrollView, UIScrollViewDelegate {
        
        /** Cell Views */
        var cells: [HabitListCalendar.Scroll.Cell] = []
        var container: HabitListCalendar.Scroll.Cell!
        
        weak var calendar: HabitListCalendar!
        
        // MARK: - Deploy
        
        override func view_deploy() {
            super.view_deploy()
            //isPagingEnabled = true
            delegate = self
            showsVerticalScrollIndicator = false
            
            contentSize = CGSize(width: bounds.width, height: bounds.height * 11)
            contentOffset = CGPoint(x: 0, y: bounds.height * 6)
            for i in 0 ..< 13 {
                let cell = HabitListCalendar.Scroll.Cell(
                    frame: CGRect(
                        x: 0,
                        y: CGFloat(i) * bounds.height,
                        width: bounds.width,
                        height: bounds.height
                    )
                )
                cell.label.text = data(offset: i - 6)
                cells.append(cell)
                addSubview(cell)
                
                if i == 6 {
                    container = cell
                }
            }
        }
        
        // MARK: - Bounds
        
        override func view_bounds() {
            super.view_bounds()
            contentSize = CGSize(width: bounds.width, height: bounds.height * 11)
            contentOffset = CGPoint(x: 0, y: bounds.height * 6)
            for (i, cell) in cells.enumerated() {
                cell.label.text = data(offset: i - 6)
                cell.frame = CGRect(
                    x: 0,
                    y: CGFloat(i) * bounds.height,
                    width: bounds.width,
                    height: bounds.height
                )
                if i == 6 {
                    container = cell
                }
            }
        }
        
        // MARK: - Data
        
        /** Get the offset date */
        func data(offset: Int) -> String {
            let date = calendar?.date ?? Date()
            return Format.yyyy年MM月.string(from: date.advance(.month, offset))
        }
        
        // MARK: - UIScrollViewDelegate
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            calendar.calendar(hidden: 0.5)
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                scrollViewDidEndDecelerating(scrollView)
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let offset = Int((scrollView.contentOffset.y + scrollView.bounds.height / 2) / scrollView.bounds.height)
            let y = CGFloat(offset) * bounds.height
            let new = calendar.date.advance(.month, offset - 6)
            UIView.animate(withDuration: 0.25, animations: {
                self.contentOffset.y = y
            }, completion: { _ in
                self.calendar.date = new
                self.view_bounds()
                self.calendar.calendar(show: 0.5)
            })
        }
        
        // MARK: - Touch

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.next?.touchesBegan(touches, with: event)
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesMoved(touches, with: event)
            self.next?.touchesMoved(touches, with: event)
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            self.next?.touchesEnded(touches, with: event)
        }
    }
    
}


extension HabitListCalendar.Scroll {
    
    class Cell: View {
        
        let label = Views.Label.title("2018年12月")
        
        // MARK: - View Deploy
        
        override func view_deploy() {
            super.view_deploy()
            //label.backgroundColor = Color.gray.halftone
            label.isUserInteractionEnabled = true
            addSubview(label)
            view_bounds()
        }
        
        override func view_bounds() {
            super.view_bounds()
            label.frame = bounds
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
        }
        
    }
    
}

// MARK: - Infos

extension HabitListCalendar {
    
    class Table: TableView, UITableViewDataSource, UITableViewDelegate {
        
        var values: [[HabitUnit]] = []
        
        override func view_deploy() {
            super.view_deploy()
            register(
                HabitListCalendar.Table.Cell.self,
                forCellReuseIdentifier: "Cell"
            )
            register(
                HabitListCalendar.Table.Header.self,
                forHeaderFooterViewReuseIdentifier: "Header"
            )
            dataSource = self
            delegate = self
            
            DispatchQueue.main.async {
                self.separatorStyle = .none
            }
            
            showsVerticalScrollIndicator = false
            
            tableFooterView = UIView()
        }
        
        // MARK: UITableViewDataSource
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return values.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return values[section].count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HabitListCalendar.Table.Cell
            let unit = values[indexPath.section][indexPath.row]
            cell.label.text = "\(unit.habit.obj.name) \(Format.time_text(second: unit.obj.length))"
            cell.view_update(index: indexPath, view: self)
            return cell
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! HabitListCalendar.Table.Header
            switch section {
            case 0:  view.label.text = "上午"
            case 1:  view.label.text = "下午"
            default: view.label.text = "晚上"
            }
            view.view_update(index: IndexPath(row: 0, section: section), view: self)
            return view
        }
        
        // MARK: UITableViewDelegate
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return values[section].count > 0 ? 40 : 0
        }
        
    }
    
}

extension HabitListCalendar.Table {
    
    class Header: TableViewHeaderFooter {
        
        var label: UILabel = Views.Label.normal("上午", alignment: .left)
        
        override func view_load() {
            super.view_load()
            label.textAlignment = .left
            addSubview(label)
        }
        
        override func view_reload() {
            super.view_reload()
            view_bounds()
        }
        
        override func view_bounds() {
            super.view_bounds()
            label.frame = CGRect(
                x: 20, y: 0,
                width: bounds.width - 40,
                height: bounds.height
            )
        }
    }
    
    class Cell: TableViewCell {
        
        var label: UILabel = Views.Label.normal("", alignment: .left)
        
        override func view_load() {
            super.view_load()
            addSubview(label)
        }
        
        override func view_reload() {
            super.view_reload()
            view_bounds()
        }
        
        override func view_bounds() {
            super.view_bounds()
            label.frame = CGRect(
                x: 40, y: 0,
                width: view!.bounds.width - 60,
                height: bounds.height
            )
        }
    }
}
