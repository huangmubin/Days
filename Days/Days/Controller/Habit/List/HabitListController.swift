//
//  HabitListController.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitListController: BaseController, HabitListDays_Delegate {

    //var objs: [Habit] = []
    
    /** Update the date */
    func reload_date() {
        app.habits.forEach({ $0.is_animation = true })
        collect?.reloadData()
        top.update(date: app.date)
        DispatchQueue.main.delay(time: 1, execute: {
            app.habits.forEach({ $0.is_animation = false })
        })
    }
    
    // MARK: - View Life
    
    var is_load: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observer(
            name: LocalNotification.Keys.Request.stopwatch.notification,
            selector: #selector(local_user_stopwatch(_:)),
            object: LocalNotification.local
        )
        
        app.reload(habit: true)
        
        collect.controller = self
        collect.register(HabitListCollect.Cell.self, forCellWithReuseIdentifier: "Cell")
        collect.dataSource = collect
        collect.delegate = collect
        collect.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let obj = messages.removeValue(forKey: Key.Habit.append) as? Habit {
            app.append(habit: obj)
            collect.insertItems(
                at: [IndexPath(app.habits)]
            )
        }
        
        if let obj = messages.removeValue(forKey: Key.Habit.update) as? Habit {
            obj.obj.update()
            reload(habit: obj)
        }
        
        if let obj = messages.removeValue(forKey: Key.Habit.delete) as? Habit {
            app.delete(habit: obj)
            collect.deleteItems(
                at: [IndexPath(row: app.habits.count, section: 0)]
            )
        }
        
        if let obj = messages.removeValue(forKey: Key.Habit.Unit.append) as? HabitUnit {
            obj.habit.units(insert: obj.obj.date, unit: obj)
            obj.obj.id = SQLite.HabitUnit.new_id
            obj.obj.insert()
            reload(habit: obj.habit)
        }
        
        if let obj = messages.removeValue(forKey: Key.Habit.Unit.delete) as? Habit {
            reload(habit: obj)
        }
        
        if is_load {
            is_load = false
            DispatchQueue.main.delay(time: 1, execute: {
                app.habits.forEach({ $0.is_animation = false })
            })
        }
        
        if let unit = timer_unit() {
            DispatchQueue.main.async {
                self.performSegue(
                    withIdentifier: "Timer",
                    sender: unit
                )
            }
        }
    }
    
    func timer_unit() -> HabitUnit? {
        if let unit = TimerController.unit() {
            if let habit = app.habits.find(condition: { $0.obj.id == unit.obj.belong }) {
                unit.habit = habit
                return unit
            }
        }
        TimerController.update(timer: nil)
        return nil
    }
    
    // MARK: - Reload View
    
    /** 动画方式重载 Cell */
    func reload(habit: Habit) {
        if let row = app.habits.index(where: { $0 === habit }) {
            if let cell = collect.cellForItem(at: IndexPath(row: row, section: 0)) as? CollectionViewCell {
                UIView.animate(withDuration: 0.25, animations: {
                    cell.view_reload()
                })
            }
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
        app.date = date
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
        if let obj = segue.controller as? HabitUnitEditController {
            let habit = sender as! Habit
            obj.unit = HabitUnit(habit)
            obj.unit.obj.start = app.date(decrease: habit.obj.space)
        }
        if let obj = segue.controller as? TimerController {
            obj.unit = sender as! HabitUnit
        }
    }
    
    // MARK: - Orientation
    
    override func orientation_changed_action() {
        collect.reloadData()
    }
    
    // MARK: - KeyboardDelegate
    
    override func keyboard(_ board: Keyboard) -> String? {
        if let date = board.value as? Date {
            app.date = date
            reload_date()
            return nil
        } else {
            return "日期不合法"
        }
    }
    
    // MARK: - Notification
    
    @objc func local_user_stopwatch(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let key = userInfo["Key"] as? String {
                if key == LocalNotification.Keys.Action.save {
                    if let unit = timer_unit() {
                        let close = (SQLite.default.db == nil)
                        if close {
                            SQLite.default.open()
                        }
                        unit.habit.units(insert: unit.obj.date, unit: unit)
                        unit.obj.id = SQLite.HabitUnit.new_id
                        unit.obj.insert()
                        reload(habit: unit.habit)
                        TimerController.update(timer: nil)
                        if close {
                            SQLite.default.close()
                        }
                    }
                }
            }
        }
    }
    
}
