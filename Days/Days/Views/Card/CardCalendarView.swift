//
//  CardCalendarView.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol CardCalendarViewDelegate: class {
    func cardCalendar(view: CardCalendarView, update date: Date)
    func cardCalendar(view: CardCalendarView, is_sick date: Date) -> Bool
    func cardCalendar(view: CardCalendarView, is_done date: Date) -> Bool
}

class CardCalendarView: CardBaseView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CardCalendarViewDelegate {
    
    func cardCalendar(view: CardCalendarView, update date: Date) {}
    func cardCalendar(view: CardCalendarView, is_sick date: Date) -> Bool { return false }
    func cardCalendar(view: CardCalendarView, is_done date: Date) -> Bool { return false }
    
    // MARK: - Values
    
    /**  */
    weak var delegate: CardCalendarViewDelegate?
    
    /** 当前代表日期 */
    var date: Date = Date() {
        didSet {
            delegate?.cardCalendar(view: self, update: date)
            date_button.setTitle(Format.yyyy年MM月dd日.string(from: date), for: .normal)
            view_bounds_date()
        }
    }
    
    /** 更新日期 */
    func update(date: Date) {
        self.date = date
        first = date.first(.month).first(.weekday)
        collect.reloadData()
    }
    
    /** 当前显示日历的首个单元时间 */
    var first: Date = Date().first(.month).first(.weekday)
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        container.backgroundColor = Color.white
        
        clipsToBounds = true
        date = Date()
        
        addSubview(date_button)
        addSubview(switch_button)
        addSubview(collect)
        for day in week {
            addSubview(day)
        }
        
        date_button.addTarget(self, action: #selector(date_action(_:)), for: .touchUpInside)
        switch_button.addTarget(self, action: #selector(switch_action(_:)), for: .touchUpInside)
        
        collect.dataSource = self
        collect.delegate = self
        delegate = self
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        view_bounds_date()
        
        switch_button.frame = CGRect(
            x: bounds.width - 60, y: 10,
            width: 60, height: 60
        )
        
        let size_width = (bounds.width - 40) / 7
        if size_width != cell_size.width {
            cell_size = CGSize(width: size_width, height: size_width)
            collect.reloadData()
        }
        
        collect.frame = CGRect(
            x: 20, y: 80 + size_width,
            width: bounds.width - 40,
            height: (bounds.width - 40) / 7 * 6
        )
        
        for (i, day) in week.enumerated() {
            day.frame = CGRect(
                x: CGFloat(i) * size_width + 20,
                y: 80, width: size_width, height: size_width
            )
        }
    }
    
    func view_bounds_date() {
        date_button.sizeToFit()
        date_button.frame = CGRect(
            x: 20, y: (80 - date_button.bounds.height) / 2,
            width: max(date_button.bounds.width, bounds.width - 80),
            height: date_button.bounds.height
        )
    }
    
    // MARK: - Date
    
    let date_button: UIButton = Views.Button.title()
    
    @objc func date_action(_ sender: UIButton) {
        let key = KeyboardDate()
        key.delegate = self
        key.update(date: date)
        key.update(title: "输入日期")
        key.push()
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        if let date = board.value as? Date {
            self.date = date
            return nil
        } else {
            return "日期不合法"
        }
    }
    
    // MARK: - Switch
    
    let switch_button: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_open"))
    
    @objc func switch_action(_ sender: UIButton) {
        let height: CGFloat = (self.frame.height == 80 ? (UIScreen.main.bounds.width - 40) + 80 : 80)
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.size.height = height
            self.table.update_content_size()
        })
    }
    
    // MARK: - Weekday
    
    let week: [UILabel] = {
        var labels = [UILabel]()
        for day in ["日", "一", "二", "三", "四", "五", "六", ] {
            let label = UILabel()
            label.textColor = Color.gray.halftone
            label.font = Font.text.m
            label.textAlignment = .center
            label.text = day
            labels.append(label)
        }
        return labels
    }()
    
    // MARK: - Collection
    
    let collect: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = CollectionView(frame: CGRect(x: 20, y: 80, width: 300, height: 300), collectionViewLayout: layout)
        view.layout = layout
        view.isScrollEnabled = false
        view.backgroundColor = Color.white
        view.register(CardCalendarView.Cell.self, forCellWithReuseIdentifier: "Cell")
        return view
    }()
    
    var cell_size = CGSize(
        width: (UIScreen.main.bounds.width - 40) / 7,
        height: (UIScreen.main.bounds.width - 40) / 7
    )
    
    var cell_selected: CardCalendarView.Cell?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCalendarView.Cell
        cell.view_update(index: indexPath, view: self)
        collection(update: cell, index: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cell_size
    }
    
    func collection(update cell: CardCalendarView.Cell, index: IndexPath) {
        let date = first.advance(.day, index.row)
        cell.day.text = date.day.description
        
        let sick = delegate?.cardCalendar(view: self, is_sick: date) == true
        let done = delegate?.cardCalendar(view: self, is_done: date) == true
        
        let sick_color = habit.color.withAlphaComponent(0.5)
        let normal_color = Color.white
        let done_color = habit.color
        
        switch (date.month == self.date.month, date.day == self.date.day) {
        case (true, true):
            cell_selected = cell
            if sick {
                cell.back.backgroundColor   = sick_color
                cell.select.backgroundColor = normal_color
                cell.day.textColor          = normal_color
            } else if done {
                cell.back.backgroundColor   = done_color
                cell.select.backgroundColor = normal_color
                cell.day.textColor          = normal_color
            } else {
                cell.back.backgroundColor   = normal_color
                cell.select.backgroundColor = Color.dark
                cell.day.textColor          = Color.dark
            }
        case (true, false):
            if sick {
                cell.back.backgroundColor   = sick_color
                cell.select.backgroundColor = UIColor.clear
                cell.day.textColor          = normal_color
            } else if done {
                cell.back.backgroundColor   = done_color
                cell.select.backgroundColor = done_color
                cell.day.textColor          = Color.white
            } else {
                cell.back.backgroundColor   = normal_color
                cell.select.backgroundColor = normal_color
                cell.day.textColor          = Color.dark
            }
        case (false, _):
            cell.back.backgroundColor   = normal_color
            cell.select.backgroundColor = normal_color
            cell.day.textColor          = Color.gray.light
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        date = first.advance(.day, indexPath.row)
        if let cell = cell_selected {
            collection(update: cell, index: cell.index)
        }
        if let cell = collect.cellForItem(at: indexPath) as? CardCalendarView.Cell {
            collection(update: cell, index: indexPath)
        }
    }
    
}

// MARK: - cell

extension CardCalendarView {
    
    class Cell: CollectionViewCell {
        
        // MARK: - Load
        
        override func view_load() {
            super.view_load()
            addSubview(back)
            addSubview(select)
            addSubview(day)
        }
        
        override func view_reload() {
            super.view_reload()
            
            back.frame = CGRect(
                x: 1, y: 1,
                width: bounds.width - 2,
                height: bounds.height - 2
            )
            
            back.corner = back.bounds.width * 0.2
            
            select.frame = CGRect(
                x: 8,
                y: bounds.height * 0.8,
                width: bounds.width - 16,
                height: 2
            )
            
            day.frame = back.frame
        }
        
        // MARK: - Views
        
        let back: View = View(corner: 2)
        let select: View = View(corner: 1)
        
        let day: UILabel = Views.Label.normal("")
    }
    
}
