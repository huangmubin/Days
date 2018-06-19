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
    var date: Date = Date() {
        didSet {
            objs.forEach({
                $0.date = date
                $0.is_animation = true
            })
            collect?.reloadData()
            date_button?.setTitle(Format.day_month_week(date), for: .normal)
            DispatchQueue.main.delay(time: 1, execute: {
                self.objs.forEach({
                    $0.is_animation = false
                })
            })
        }
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
            // TODO: - AppStore Delete true
            //top.left_button.isHidden = false
            top.vc = self
            top.left_button.isHidden = true
        }
    }
    
    // MARK: - Entry
    
    @IBOutlet weak var entry: HabitListEntry!
    @IBOutlet weak var entry_height: NSLayoutConstraint!
    
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
    }
    
    // MARK: - Orientation
    
    override func orientation_changed_action() {
        collect.reloadData()
    }
    
    // MARK: - Date
    
    @IBOutlet weak var date_button: UIButton! {
        didSet {
            date_button.setTitleColor(Color.gray.halftone, for: .normal)
            date_button.titleLabel?.font = Font.text.s
        }
    }
    
    @IBAction func date_action(_ sender: UIButton) {
        let key = KeyboardDate()
        key.delegate = self
        key.update(date: date)
        key.update(title: "输入日期")
        key.push()
    }
    
    @IBAction func date_next_action() {
        date = date.advance(.day, 1)
    }
    
    @IBAction func date_last_action() {
        date = date.advance(.day, -1)
    }
    
    // MARK: - Date Gesture
    
    @IBAction func pan_gesture_action(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended:
            let move = sender.translation(in: self.view).x
            if move > 50 {
                date_last_action()
            } else if move < -50 {
                date_next_action()
            }
        default: break
        }
    }
    
    // MARK: - KeyboardDelegate
    
    override func keyboard(_ board: Keyboard) -> String? {
        if let date = board.value as? Date {
            self.date = date
            return nil
        } else {
            return "日期不合法"
        }
    }
}
