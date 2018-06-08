//
//  HabitUnitListController.swift
//  Days
//
//  Created by Myron on 2018/5/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitListController: BaseController, HabitObjectController, UITableViewDataSource, UITableViewDelegate {

    var habit: Habit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        top.title.setTitle("打卡记录", for: .normal)
        top.subtitle.text = habit.obj.name
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = habit.dates.index(of: habit.date.date) {
            table.scrollToRow(
                at: IndexPath(row: 0, section: index),
                at: UITableViewScrollPosition.top,
                animated: true
            )
        }
        
        if let unit = messages.removeValue(forKey: Key.Habit.Unit.append) as? HabitUnit {
            unit.obj.id = SQLite.HabitUnit.new_id
            unit.obj.insert()
            habit.units(insert: habit.date.date, unit: unit)
            habit.chart.units(update: habit.date.date)
            habit.dates_reload()
            table.reloadData()
        }
        
        if let unit = messages.removeValue(forKey: Key.Habit.Unit.update) as? HabitUnit {
            unit.obj.update()
            habit.chart.units(update: habit.date.date)
            table.reloadData()
        }
    }
    
    // MARK: - Top
    
    @IBOutlet weak var top: HabitListTop!
    
    @IBAction func top_right_action(_ sender: UIButton) {
        let unit = HabitUnit(habit)
        performSegue(withIdentifier: "UnitEdit", sender: unit)
    }
    
    // MARK: - Table View
    
    @IBOutlet weak var table: UITableView! {
        didSet {
            table.register(HabitUnitListCell.self, forCellReuseIdentifier: "Cell")
            table.register(HabitUnitListHeader.self, forHeaderFooterViewReuseIdentifier: "Header")
            table.separatorStyle = .none
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return habit.dates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habit.units(date: habit.dates[section]).count
    }
    
    // MARK: Cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HabitUnitListCell
        let units = habit.units(date: habit.dates[indexPath.section])
        cell.unit = units[indexPath.row]
        if units.count <= 1 {
            cell.type = .total
        } else if indexPath.row == 0 {
            cell.type = .top
        } else if indexPath.row == (units.count - 1) {
            cell.type = .bottom
        } else {
            cell.type = .center
        }
        cell.view_update(index: indexPath, controller: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! HabitUnitListHeader
        header.view_update(index: IndexPath(row: 0, section: section), controller: self)
        let units = habit.units(date: habit.dates[section])
        header.title.text = Format.yyyy年MM月dd日.string(from: Date(habit.dates[section]))
        header.title.text = header.title.text! + (units.count(value: { $0.obj.length }) >= habit.obj.frequency ? " - 达成" : "")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // MARK: - Select
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {        
            self.performSegue(
                withIdentifier: "UnitEdit",
                sender: self.habit.units(
                    date: self.habit.dates[indexPath.section]
                    )[indexPath.row]
            )
        }
    }
    
    // MARK: - Edit
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if habit.units(remove: indexPath) {
                tableView.deleteSections([indexPath.section], with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadSections([indexPath.section], with: .automatic)
            }
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let edit = segue.controller as? HabitUnitEditController {
            edit.unit = sender as! HabitUnit
        }
    }
    
    
}
