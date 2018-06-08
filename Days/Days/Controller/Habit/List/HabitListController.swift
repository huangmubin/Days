//
//  HabitListController.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitListController: BaseController {

    var objs: [Habit] = []
    
    // MARK: - View Life
    
    var is_load: Bool = true
    
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
            obj.event_create()
            obj.diary_create()
            objs.append(obj)
        }
        
        if let obj = messages.removeValue(forKey: Key.Habit.update) as? Habit {
            obj.obj.update()
        }
        
        if let obj = messages.removeValue(forKey: Key.Habit.delete) as? Habit {
            if let row = objs.index(where: { $0 === obj }) {
                objs.remove(at: row)
                let index = IndexPath(row: row, section: 0)
                table.deleteRows(at: [index], with: .left)
            }
            obj.delete()
        }
        
        if is_load {
            is_load = false
        } else {
            table.reloadData()
        }
    }
    
    // MARK: - Top
    
    @IBOutlet weak var top: HabitListTop! {
        didSet {
            // TODO: - AppStore Delete true
            //top.left_button.isHidden = false
            top.vc = self
            top.left_button.isHidden = true
        }
    }
    
    @IBAction func top_entry_switch_action(_ sender: UIButton) {
        let height: CGFloat = (entry_height.constant == 0 ? 90 : 0)
        UIView.animate(withDuration: 0.25, animations: {
            self.entry_height.constant = height
            self.view.layoutIfNeeded()
        })
        /*
        // TODO: - AppStore Delete
        SQLite.default.log?.print_sql_text()
         */
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
        if let obj = segue.controller as? HabitObjectController {
            if let habit = sender as? Habit {
                obj.habit = habit
            } else {
                obj.habit = Habit()
            }
        }
    }
    
}
