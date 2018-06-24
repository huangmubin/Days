//
//  HabitListController.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitListController: BaseController, HabitListDays_Delegate {

    var objs: [Habit] = []
    var date: Date = Date()
    
    /** Update the date */
    func reload_date() {
        objs.forEach({
            $0.date = date
            $0.is_animation = true
        })
        collect?.reloadData()
        top.update(date: date)
        DispatchQueue.main.delay(time: 1, execute: {
            self.objs.forEach({
                $0.is_animation = false
            })
        })
    }
    
    // MARK: - View Life
    
    var is_load: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objs = SQLite.Habit.find().sorted(by: {
            $0.sort < $1.sort
        }).map({
            let obj = Habit($0)
            obj.is_animation = true
            return obj
        })
        
        collect.controller = self
        collect.register(HabitListCollect.Cell.self, forCellWithReuseIdentifier: "Cell")
        collect.dataSource = collect
        collect.delegate = collect
        collect.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        objs.forEach({ $0.date = date })
        
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
            }
            obj.delete()
        }
        
        if is_load {
            is_load = false
            DispatchQueue.main.delay(time: 1, execute: {
                self.objs.forEach({ $0.is_animation = false })
            })
        } else {
            collect.reloadData()
        }
    }
    
    // MARK: - Top
    
    @IBOutlet weak var top: HabitListTop! {
        didSet {
            top.controller = self
        }
    }
    
    // MARK: - Days and HabitListDays_Delegate
    
    @IBOutlet weak var days: HabitListDays! {
        didSet {
            days.delegate = self
        }
    }
    
    func habitListDays(update date: Date) {
        self.date = date
        self.top.update(date: date)
    }
    
    // MARK: - Table
    
    @IBOutlet weak var collect: HabitListCollect!
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let obj = segue.controller as? HabitObjectController {
            if let habit = sender as? Habit {
                obj.habit = habit
            } else {
                obj.habit = Habit()
            }
        }
        if let obj = segue.controller as? HabitUnitListController {
            obj.habit = sender as! Habit
        }
    }
    
    // MARK: - Orientation
    
    override func orientation_changed_action() {
        collect.reloadData()
    }
    
    // MARK: - KeyboardDelegate
    
    override func keyboard(_ board: Keyboard) -> String? {
        if let date = board.value as? Date {
            self.date = date
            self.reload_date()
            return nil
        } else {
            return "日期不合法"
        }
    }
}
