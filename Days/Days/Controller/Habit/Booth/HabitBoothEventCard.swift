//
//  HabitBoothEventCard.swift
//  Days
//
//  Created by Myron on 2018/5/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitBoothEventCard: CardStandardView, UITableViewDataSource, UITableViewDelegate {
    
    var event: Event!
    
    // MARK: - View Deploy
    
    override func reload() {
        super.reload()
        title.text = event.obj.name
        title.sizeToFit()
        update_heights()
        table_view.reloadData()
        var height = max(heights.count(value: {$0}), 30) + 60 + 30
        height = edge.top + title.frame.height + space + height + edge.bottom
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.size.height = height
            self.table.update_content_size()
        })
    }
    
    override func view_deploy() {
        super.view_deploy()
        container.addSubview(table_view)
        container.addSubview(append)
        table_view.delegate = self
        table_view.dataSource = self
        append.addTarget(self, action: #selector(append_action), for: .touchUpInside)
    }
    
    override func view_bounds() {
        super.view_bounds()
        table_view.frame = CGRect(
            x: 0, y: 30,
            width: container.bounds.width,
            height: container.bounds.height - 60 - 30
        )
        let y = heights.count == 0 ? (container.bounds.height - 60) / 2 : table_view.frame.maxY
        append.frame = CGRect(
            x: 0, y: y,
            width: table_view.bounds.width,
            height: 60
        )
    }
    
    // MARK: - detail
    
    
    
    // MARK: - Table View
    
    let table_view: TableView = {
        let view = TableView()
        view.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        view.separatorColor = Color.white
        view.separatorInset.left = 38
        view.separatorInset.right = 4
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.register(HabitBoothEventCard.Cell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.units.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HabitBoothEventCard.Cell
        cell.unit = event.units[indexPath.row]
        cell.view_update(index: indexPath, view: self)
        return cell
    }
    
    // MARK: - Height
    
    var heights: [CGFloat] = []
    func update_heights() {
        heights.removeAll(keepingCapacity: true)
        let w = bounds.width - edge.left - edge.right
        for unit in event.units {
            heights.append(
                HabitBoothEventCard.Cell.height(
                    unit: unit,
                    width: w
                )
            )
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heights[indexPath.row]
    }
    
    // MARK: - Add
    
    let append: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "but_add"), for: .normal)
        button.tintColor = Color.dark
        return button
    }()
    
    @objc func append_action() {
        let view = Keyboard()
        view.update(title: "新建事件")
        view.delegate = self
        view.push()
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        let unit = EventUnit(event)
        unit.obj.id = SQLite.EventUnit.new_id
        unit.obj.name = board.value as! String
        //unit.obj.note = "测试的详细内容。测试的详细内容。测试的详细内容。测试的详细内容。测试的详细内容。测试的详细内容。测试的详细内容。测试的详细内容。测试的详细内容。测试的详细内容。"
        unit.obj.insert()
        event.units.append(unit)
        reload()
        return nil
    }
}

// MARK: - Cell

extension HabitBoothEventCard {
    
    class Cell: TableViewCell {
        
        var unit: EventUnit!
        
        @objc func select_action() {
            unit.obj.is_done = !unit.obj.is_done
            unit.obj.update()
            select.isSelected = unit.obj.is_done
        }
        
        // MARK: - Load
        
        override func view_load() {
            super.view_load()
            backgroundColor = UIColor.clear
            addSubview(select)
            addSubview(title)
            addSubview(detail)
            select.addTarget(self, action: #selector(select_action), for: .touchUpInside)
        }
        
        override func view_reload() {
            super.view_reload()
            select.isSelected = unit.obj.is_done
            title.text = unit.obj.name
            detail.text = unit.obj.note
            select.setImage(Resource.image("but_check", unit.event.habit.obj.color), for: .selected)
            view_bounds()
        }
        
        override func view_bounds() {
            super.view_bounds()
            let select_size: CGFloat = 30
            select.frame = CGRect(
                x: 8, y: (bounds.height - select_size) / 2,
                width: select_size, height: select_size
            )
            
            let bounds_size: CGSize = CGSize(width: bounds.width - select.frame.maxX - 12, height: 1000)
            let title_size = title.sizeThatFits(bounds_size)
            let detail_size = detail.sizeThatFits(bounds_size)
            title.frame = CGRect(
                x: select.frame.maxX + 4, y: (bounds.height - title_size.height - detail_size.height) / 2,
                width: bounds_size.width, height: title_size.height
            )
            detail.frame = CGRect(
                x: title.frame.minX, y: title.frame.maxY,
                width: bounds_size.width, height: detail_size.height
            )
        }
        
        // MARK: - Views
        
        let select: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "but_check"), for: .selected)
            button.setImage(#imageLiteral(resourceName: "but_uncheck"), for: .normal)
            return button
        }()
        
        let title: UILabel = {
            let label = UILabel()
            label.font = Font.text.m
            label.textColor = Color.dark
            label.numberOfLines = 0
            return label
        }()
        
        let detail: UILabel = {
            let label = UILabel()
            label.font = Font.hint.s
            label.textColor = Color.gray.halftone
            label.numberOfLines = 0
            return label
        }()
        
        // MARK: - Height
        
        static let cell: HabitBoothEventCard.Cell = {
            let cell = HabitBoothEventCard.Cell(frame: CGRect.zero)
            cell.view_load()
            return cell
        }()
        class func height(unit: EventUnit, width: CGFloat) -> CGFloat {
            cell.unit = unit
            cell.frame = CGRect(x: 0, y: 0, width: width, height: 1000)
            cell.view_reload()
            return max(30, cell.title.frame.height + cell.detail.frame.height + 8)
        }
    }
    
}
