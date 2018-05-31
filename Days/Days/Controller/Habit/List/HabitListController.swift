//
//  HabitListController.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitListController: ViewController {

    var objs: [Habit] = []
    
    // MARK: - View Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objs = SQLite.Habit.find().sorted(by: {
            $0.sort < $1.sort
        }).map({ Habit($0) })
        table.controller = self
        table.dataSource = table
        table.delegate = table
        table.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let obj = messages.removeValue(forKey: Key.Habit.append) as? Habit {
            obj.obj.id = SQLite.Habit.new_id
            obj.obj.sort = obj.obj.id
            obj.obj.insert()
            obj.chart_create()
            objs.append(obj)
            DispatchQueue.main.async {            
                self.table.insertRows(at: [IndexPath(self.objs)], with: UITableViewRowAnimation.bottom)
            }
        }
    }
    
    // MARK: - Top
    
    @IBOutlet weak var top: HabitListTop!
    
    @IBAction func top_entry_switch_action(_ sender: UIButton) {
        let height: CGFloat = (entry_height.constant == 0 ? 90 : 0)
        UIView.animate(withDuration: 0.25, animations: {
            self.entry_height.constant = height
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Entry
    
    @IBOutlet weak var entry: HabitListEntry!
    @IBOutlet weak var entry_height: NSLayoutConstraint!
    
    // MARK: - Table
    
    @IBOutlet weak var table: HabitListTable! {
        didSet {
            table.dataSource = table
            table.delegate = table
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let edit = segue.controller as? HabitEditController {
            edit.habit = Habit()
        }
        if let booth = segue.controller as? HabitBoothController {
            booth.habit = sender as! Habit
        }
    }
    
}
