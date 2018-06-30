//
//  TimerController.swift
//  Days
//
//  Created by Myron on 2018/6/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TimerController: BaseController {
    
    var habit: Habit!
    
    // MARK: - View Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        top.title.setTitle(habit.obj.name, for: .normal)
        
        if habit.obj.is_time {
            timer = stopwatch
            counter.isHidden = true
            menu.update(start: true)
        } else {
            timer = counter
            timer.isHidden = true
            timer.run()
            menu.update(start: false)
        }
        
        top.controller  = self
        menu.controller = self
        timer.controller = self
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
    }
    
    func save_action() {
        
    }
}
