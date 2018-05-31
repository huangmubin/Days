//
//  HabitUnitEditTimerCard.swift
//  Days
//
//  Created by Myron on 2018/5/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitEditTimerCard: CardStandardView {

    var value: (start: Date, end: Date) = (Date(), Date())
    
    // MARK: - Reload
    
    override func reload() {
        super.reload()
        unit_obj.habit.date = Date().first(.day).addingTimeInterval(Double(Date().time))
        value.start = unit_obj.obj.start
        value.end   = value.start.addingTimeInterval(TimeInterval(unit_obj.habit.obj.space))
        update_buttons()
    }
    
    func update_buttons() {
        start.setTitle(
            Format.clock(second: value.start.time),
            for: .normal
        )
        end.setTitle(
            Format.clock(second: value.end.time),
            for: .normal
        )
        let space = value.end.time1970 - value.start.time1970
        duration.text = Format.time_text(
            second: space
        )
        switch space {
        case 600:
            small.backgroundColor = Color.dark
            medium.backgroundColor = Color.gray.light
            big.backgroundColor = Color.gray.light
            small.setTitleColor(Color.white, for: .normal)
            medium.setTitleColor(Color.dark, for: .normal)
            big.setTitleColor(Color.dark, for: .normal)
        case 1800:
            small.backgroundColor = Color.gray.light
            medium.backgroundColor = Color.dark
            big.backgroundColor = Color.gray.light
            small.setTitleColor(Color.dark, for: .normal)
            medium.setTitleColor(Color.white, for: .normal)
            big.setTitleColor(Color.dark, for: .normal)
        case 3600:
            small.backgroundColor = Color.gray.light
            medium.backgroundColor = Color.gray.light
            big.backgroundColor = Color.dark
            small.setTitleColor(Color.dark, for: .normal)
            medium.setTitleColor(Color.dark, for: .normal)
            big.setTitleColor(Color.white, for: .normal)
        default:
            small.backgroundColor = Color.gray.light
            medium.backgroundColor = Color.gray.light
            big.backgroundColor = Color.gray.light
            small.setTitleColor(Color.dark, for: .normal)
            medium.setTitleColor(Color.dark, for: .normal)
            big.setTitleColor(Color.dark, for: .normal)
        }
        
    }
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "时间"
        container.backgroundColor = Color.white
        
        addSubview(duration)
        container.addSubview(start)
        container.addSubview(end)
        container.addSubview(gap_label)
        container.addSubview(small)
        container.addSubview(medium)
        container.addSubview(big)
        
        duration.sizeToFit()
        
         start.addTarget(self, action: #selector(start_action), for: .touchUpInside)
           end.addTarget(self, action: #selector(end_action), for: .touchUpInside)
         small.addTarget(self, action: #selector(small_action), for: .touchUpInside)
        medium.addTarget(self, action: #selector(medium_action), for: .touchUpInside)
           big.addTarget(self, action: #selector(big_action), for: .touchUpInside)
    }
    
    override func view_bounds() {
        super.view_bounds()
        duration.frame = CGRect(
            x: bounds.width - edge.right - 60,
            y: container.frame.minY - space - duration.frame.height,
            width: 60,
            height: duration.frame.height
        )
        
        let h = (container.bounds.height - 20) / 3
        gap_label.sizeToFit()
        gap_label.center = CGPoint(
            x: container.bounds.width / 2,
            y: h
        )
        
        start.frame = CGRect(
            x: 0, y: 0,
            width: (container.bounds.width - gap_label.frame.width - 10) / 2,
            height: h * 2
        )
        end.frame = CGRect(
            x: gap_label.frame.maxX + 5, y: 0,
            width: start.frame.width,
            height: start.frame.height
        )
        
        let w = (container.bounds.width - 20) / 3
        for (i, button) in [small, medium, big].enumerated() {
            button.frame = CGRect(
                x: CGFloat(i) * (w + 10),
                y: start.frame.maxY + 20,
                width: w, height: h
            )
        }
    }
    
    // MARK: - Duration
    
    let duration: UILabel = {
        let label = UILabel()
        label.font = Font.hint.m
        label.textColor = Color.gray.halftone
        label.text = "10分钟"
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Timer
    
    let start: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Font.text.b
        button.setTitle("00:00", for: .normal)
        button.setTitleColor(Color.dark, for: .normal)
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        return button
    }()
    
    let gap_label: UILabel = {
        let label = UILabel()
        label.text = "至"
        label.textColor = Color.dark
        label.font = Font.text.s
        label.textAlignment = .center
        return label
    }()
    
    let end: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Font.text.b
        button.setTitle("00:00", for: .normal)
        button.setTitleColor(Color.dark, for: .normal)
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func start_action() {
        let view = KeyboardTime()
        view.delegate = self
        view.update(title: "开始时间")
        view.update(date: value.start)
        view.id = "Start"
        view.push()
    }
    @objc func end_action() {
        let view = KeyboardTime()
        view.delegate = self
        view.update(title: "结束时间")
        view.update(date: value.end)
        view.push()
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        let zero = value.start.first(.day)
        var s = value.start.time1970 - zero.time1970
        var e = value.end.time1970 - zero.time1970
        
        if board.id == "Start" {
            s = board.value as! Int
            if s == 86400 {
                s = 86400 - unit_obj.habit.obj.space
                e = 86400
            } else if s >= e {
                e = min(s + unit_obj.habit.obj.space, 86400)
            }
        } else {
            e = board.value as! Int
            if e == 0 {
                s = 0
                e = unit_obj.habit.obj.space
            } else if s >= e {
                s = max(0, e - unit_obj.habit.obj.space)
            }
        }
        value.start = zero.addingTimeInterval(TimeInterval(s))
        value.end   = zero.addingTimeInterval(TimeInterval(e))
        unit_obj.obj.start = value.start
        unit_obj.obj.length = e - s
        update_buttons()
        return nil
    }
    
    // MARK: - Easy
    
    
    let small: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Font.text.s
        button.setTitle("10分钟", for: .normal)
        button.setTitleColor(Color.dark, for: .normal)
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        return button
    }()
    let medium: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Font.text.s
        button.setTitle("30分钟", for: .normal)
        button.setTitleColor(Color.dark, for: .normal)
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        return button
    }()
    let big: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Font.text.s
        button.setTitle("1小时", for: .normal)
        button.setTitleColor(Color.dark, for: .normal)
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func small_action() {
        value.end = value.start.addingTimeInterval(600)
        update_buttons()
    }
    @objc func medium_action() {
        value.end = value.start.addingTimeInterval(1800)
        update_buttons()
    }
    @objc func big_action() {
        value.end = value.start.addingTimeInterval(3600)
        update_buttons()
    }
    
    
}
