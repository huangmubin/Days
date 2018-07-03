//
//  TimerController.swift
//  Days
//
//  Created by Myron on 2018/6/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TimerController: BaseController {
    
    var unit: HabitUnit!
    
    // MARK: - View Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        top.title.setTitle(
            unit.habit.obj.name,
            for: .normal
        )
        
        if unit.habit.obj.is_time {
            timer = stopwatch
            counter.isHidden = true
            menu.update(start: true)
        } else {
            timer = counter
            stopwatch.isHidden = true
            menu.update(start: false)
            start_action()
        }
        
        top.controller  = self
        menu.controller = self
        timer.controller = self
        
        if let obj = TimerController.Unit.obj() {
            let new = obj.unit()
            new.habit = unit.habit
            unit = new
            timer.start = unit.obj.start
            timer.space = obj.space
            if !new.habit.obj.is_time {
                timer.length = obj.length
            }
            start_action()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Sub Views
    
    @IBOutlet weak var top: TimerTop!
    weak var timer: TimerView!
    @IBOutlet weak var counter: TimerCounter!
    @IBOutlet weak var stopwatch: TimerStopwatch!
    @IBOutlet weak var menu: TimerMenu!
    
    // MARK: - Actions
    
    func start_action() {
        timer.run()
        menu.start.alpha = 0
        menu.save.alpha = 1
        
        if unit.habit.obj.is_time {
            if TimerController.unit() == nil {
                unit.obj.start = timer.start
                TimerController.update(
                    timer: unit,
                    space: timer.space
                )
            }
        }
    }
    
    func save_action() {
        timer.timer?.cancel()
        timer.timer = nil
        
        TimerController.update(timer: nil)
        
        unit.obj.length = timer.length
        toSuperController(object: [Key.Habit.Unit.append: unit])
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


// MARK: - User Default

extension TimerController {
    
    class Unit: Codable {
        var habit: Int = 0
        var start: Int = 0
        var space: Int = 0
        var length: Int = 0
        var text: String = ""
        
        class func save(unit: HabitUnit?, space: Int = 0) {
            if let unit = unit {
                let obj = Unit()
                obj.habit = unit.habit.obj.id
                obj.start = unit.obj.start.time1970
                obj.space = space
                obj.length = unit.obj.length
                obj.save()
            } else {
                UserDefaults.standard.set(
                    nil,
                    forKey: Key.Timer.unit
                )
            }
        }
        
        class func obj() -> TimerController.Unit? {
            if let json = UserDefaults.standard.value(forKey: Key.Timer.unit) as? Data {
               return try? JSONDecoder().decode(TimerController.Unit.self, from: json)
            }
            return nil
        }
        
        func save() {
            if let json = try? JSONEncoder().encode(self) {
                UserDefaults.standard.set(
                    json,
                    forKey: Key.Timer.unit
                )
            }
        }
        
        func unit() -> HabitUnit {
            let unit = HabitUnit(Habit())
            unit.obj.belong = habit
            unit.obj.start  = Date(time: start)
            unit.obj.length = length
            unit.obj.note   = text
            return unit
        }
    }
    
    /** 添加记录或删除记录 */
    class func update(timer: HabitUnit?, space: Int = 0) {
        Unit.save(unit: timer, space: space)
        LocalNotification.stopwatch(
            unit: timer?.habit.obj.name,
            length: timer?.obj.length ?? 0,
            space: space
        )
    }
    
    /** 获取记录 */
    class func unit() -> HabitUnit? {
        return Unit.obj()?.unit()
    }
    
}
