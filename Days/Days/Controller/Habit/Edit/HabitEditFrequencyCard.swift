//
//  HabitEditFrequencyCard.swift
//  Days
//
//  Created by 黄穆斌 on 2018/5/26.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditFrequencyCard: CardStandardView {
    
    // MARK: - Value
    
    /** default height */
    override var default_height: CGFloat {
        return edge.top + 40 + space + 60 + edge.bottom
    }
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "目标"
        
        container.addSubview(frequency)
        container.addSubview(number)
        container.addSubview(unit)
        
        frequency.addTarget(self, action: #selector(frequency_action), for: .touchUpInside)
        
        container.backgroundColor = Color.white
    }
    
    override func reload() {
        super.reload()
        if habit.obj.is_time {
            let text = Format.time_unit(second: habit.obj.frequency)
            number.text = text.time
            unit.text = text.unit
        } else {
            number.text = "\(habit.obj.frequency)"
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
    
    func update_frequency() {
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
    
    let frequency: Button = {
        let button = Button(type: .custom)
        button.normal_color = Color.gray.light
        button.corner = 10
        button.titleLabel?.font = Font.title.m
        button.setTitleColor(Color.dark, for: .normal)
        return button
    }()
    
    @objc func frequency_action() {
        let key = Keyboard()
        key.text.keyboardType = .numberPad
        key.delegate = self
        if habit.obj.is_time {
            key.update(title: "每天多少分钟")
            key.update(text: "\(habit.obj.frequency / 60)")
        } else {
            key.update(title: "每天多少次")
            key.update(text: "\(habit.obj.frequency)")
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
            if int >= 1440 {
                return "你不能整天这样"
            }
            habit.obj.frequency = int * 60
        } else {
            habit.obj.frequency = int
        }
        reload()
        return nil
    }
    
    // MARK: - Labels
    
    let number: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = Font.title.m
        label.textColor = Color.dark
        return label
    }()
    
    let unit: UILabel = {
        let label = UILabel()
        label.text = "分钟"
        label.font = Font.text.m
        label.textColor = Color.gray.halftone
        return label
    }()
    
}
