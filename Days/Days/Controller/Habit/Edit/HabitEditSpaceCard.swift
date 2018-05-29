//
//  HabitEditSpaceCard.swift
//  Days
//
//  Created by Myron on 2018/5/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditSpaceCard: HabitEditFrequencyCard {
    
    override var title_text: String { return "默认打卡步长" }
    
    // MARK: - Init
    
    override func reload() {
        super.reload()
        if habit.obj.is_time {
            let text = Format.time_unit(second: habit.obj.space)
            number.text = text.time
            unit.text = text.unit
        } else {
            number.text = "\(habit.obj.space)"
            unit.text = "次"
        }
        
        number.sizeToFit()
        unit.sizeToFit()
        update_frequency()
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        frequency.frame = container.bounds
        
        update_frequency()
    }
    
    override func update_frequency() {
        number.center = CGPoint(
            x: frequency.center.x - unit.bounds.width / 2 - 4,
            y: frequency.center.y
        )
        unit.center = CGPoint(
            x: frequency.center.x + number.bounds.width / 2 + 4,
            y: number.center.y
        )
    }
    
    // MARK: - Buttons
    
    @objc override func frequency_action() {
        let key = Keyboard()
        key.text.keyboardType = .numberPad
        key.delegate = self
        if habit.obj.is_time {
            key.update(title: "每次多少分钟")
            key.update(text: "\(habit.obj.space / 60)")
        } else {
            key.update(title: "每次多少次")
            key.update(text: "\(habit.obj.space)")
        }
        key.push()
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        guard let text = board.value as? String else {
            return "输入不合法"
        }
        guard let int = Int(text) else {
            return "输入不合法"
        }
        if habit.obj.is_time {
            habit.obj.space = int * 60
        } else {
            habit.obj.space = int
        }
        reload()
        return nil
    }

}
