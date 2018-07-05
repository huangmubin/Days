//
//  HabitListDays_Table.swift
//  Days
//
//  Created by 黄穆斌 on 2018/6/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

extension HabitListDays {
    
    class Table: TableView, UITableViewDataSource, UITableViewDelegate {
        
        // MARK: Values
        
        /**  */
        var units: [[HabitUnit]] = []
        
        /**  */
        var heights: [[CGFloat]] = []
        
        // MARK: - Reload
        
        /** Reload the heights and then reload tableview */
        func reload() {
            Table.Cell.width = bounds.width - 40
            heights.removeAll()
            for unit_list in units {
                var height_list: [CGFloat] = []
                for unit in unit_list {
                    let info = infos(unit: unit)
                    height_list.append(
                        Cell.height(
                            name: info.name,
                            time: info.time,
                            note: info.note
                        )
                    )
                }
                heights.append(height_list)
            }
            reloadData()
        }
        
        /** update the cell */
        func update(cell: HabitListDays.Table.Cell, sec: Int, row: Int) {
            let info = infos(unit: units[sec][row])
            cell.name.text = info.name
            cell.note.text = info.note
            cell.time.text = info.time
        }
        
        /** Get the unit infos */
        func infos(unit: HabitUnit) -> (name: String, time: String, note: String) {
            return (
                unit.habit.obj.name,
                Format.time_text(second: unit.obj.length),
                unit.obj.note
            )
        }
        
        // MARK: - Deploy
        
        override func view_deploy() {
            super.view_deploy()
            register(
                HabitListDays.Table.Cell.self,
                forCellReuseIdentifier: "Cell"
            )
            register(
                HabitListDays.Table.Header.self,
                forHeaderFooterViewReuseIdentifier: "Header"
            )
            
            // Delegate
            dataSource = self
            delegate = self
            
            // Sets
            DispatchQueue.main.async {
                self.separatorStyle = .none
            }
            showsVerticalScrollIndicator = false
            tableFooterView = UIView()
        }
        
        // MARK: UITableViewDataSource
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return units.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return units[section].count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HabitListDays.Table.Cell
            update(cell: cell, sec: indexPath.section, row: indexPath.row)
            cell.view_update(index: indexPath, view: self)
            return cell
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! HabitListDays.Table.Header
            switch section {
            case 0:  view.info.text = "上午"
            case 1:  view.info.text = "下午"
            default: view.info.text = "晚上"
            }
            view.view_update(section: section, view: self)
            return view
        }
        
        // MARK: UITableViewDelegate
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return units[section].count > 0 ? 40 : 0
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return heights[indexPath.section][indexPath.row]
        }
        
    }
    
}

extension HabitListDays.Table {
    
    // MARK: - Header
    
    class Header: TableViewHeaderFooter {
        
        let info: UILabel = Views.Label.normal("", alignment: .left)
        let back: View = View()
        
        override func view_load() {
            //super.view_load()
            addSubview(back)
            addSubview(info)
        }
        
        override func view_reload() {
            super.view_reload()
            view_bounds()
        }
        
        override func view_bounds() {
            //super.view_bounds()
            back.frame = bounds
            info.frame = CGRect(
                x: 20, y: 0,
                width: bounds.width - 40,
                height: bounds.height
            )
        }
        
    }
    
}

extension HabitListDays.Table {
    
    // MARK: - Cell
    
    class Cell: TableViewCell {
        
        let name: UILabel = Views.Label.small("", alignment: .left)
        let time: UILabel = Views.Label.small("", alignment: .left)
        let note: UILabel = Views.Label.hint(small: "", alignment: .left)
        let back: View = View()
        
        override func view_load() {
            super.view_load()
            selectionStyle = .none
            
            addSubview(back)
            addSubview(name)
            addSubview(time)
            addSubview(note)
            
            note.numberOfLines = 0
        }
        
        override func view_reload() {
            super.view_reload()
            view_bounds()
        }
        
        // MARK: Bounds
        
        override func view_bounds() {
            super.view_bounds()
            
            // Time
            
            time.sizeToFit()
            time.frame.origin = CGPoint(
                x: Cell.width - Cell.edge.right - time.bounds.width,
                y: Cell.edge.top
            )
            
            // Name and Note
            
            let w = Cell.width - Cell.edge.left - Cell.edge.right - time.bounds.width
            let s = CGSize(width: w, height: 10000)
            let name_size = name.sizeThatFits(s)
            let note_size = note.sizeThatFits(s)
            
            name.frame = CGRect(
                origin: CGPoint(x: Cell.edge.left, y: Cell.edge.top),
                size: name_size
            )
            note.frame = CGRect(
                origin: CGPoint(x: Cell.edge.left, y: name.frame.maxY),
                size: note_size
            )
            
            // Back
            
            back.frame = CGRect(
                x: 0, y: 0,
                width: Cell.width,
                height: note.frame.maxY + Cell.edge.bottom
            )
        }
        
        // MARK: Height
        
        static let cell: Cell = {
            let cell = Cell(
                style: .default,
                reuseIdentifier: "CellHeight"
            )
            cell.note.numberOfLines = 0
            return cell
        }()
        
        
        static var width: CGFloat = UIScreen.main.bounds.width - 40
        static let edge: UIEdgeInsets = UIEdgeInsets(
            top: 8,
            left: 20,
            bottom: 8,
            right: 10
        )
        
        class func height(name: String, time: String, note: String) -> CGFloat {
            cell.name.text = name
            cell.time.text = time
            cell.note.text = note
            cell.view_bounds()
            return cell.back.bounds.height
        }
        
    }
    
}
