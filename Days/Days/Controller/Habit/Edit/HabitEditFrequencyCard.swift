//
//  HabitEditFrequencyCard.swift
//  Days
//
//  Created by 黄穆斌 on 2018/5/26.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditFrequencyCard: CardStandardEditView {
    
    // MARK: - Reload
    
    override func reload() {
        super.reload()
        if habit.obj.is_time {
            info.text = "\(habit.obj.frequency / 60)"
            info_sub.text = "分钟"
            info_edit.text = "默认打卡 \(Format.time_text(second: habit.obj.space))"
        } else {
            info.text = "\(habit.obj.frequency)"
            info_sub.text = habit.obj.type
            info_edit.text = "默认打卡 \(habit.obj.space)\(info_sub.text!)"
        }
        
        info_sub.text = "\(info_sub.text!)/天"
        view_bounds()
    }
    
    // MARK: - Keyboard
    
    override func normal_keyboard(_ board: Keyboard) {
        board.text.keyboardType = .numberPad
        if habit.obj.is_time {
            board.update(title: "分钟/天")
            board.update(text: "\(habit.obj.frequency / 60)")
        } else {
            board.update(title: "\(habit.obj.type!)/天")
            board.update(text: "\(habit.obj.frequency)")
        }
    }
    
    override func edit_keyboard(_ board: Keyboard) {
        board.text.keyboardType = .numberPad
        board.update(title: "默认打卡步长")
        if habit.obj.is_time {
            board.update(text: "\(habit.obj.space / 60)")
        } else {
            board.update(text: "\(habit.obj.space)")
        }
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        guard let text = board.value as? String else {
            return "输入不合法"
        }
        guard let int = Int(text) else {
            return "输入不合法"
        }
        if board.id == "normal" {
            if habit.obj.is_time {
                guard int < 1440 else { return "超过最大限制" }
                habit.obj.frequency = int * 60
            } else {
                habit.obj.frequency = int
            }
            habit.obj.space = habit.obj.frequency / 10
        } else {
            if habit.obj.is_time {
                habit.obj.space = int * 60
            } else {
                habit.obj.space = int
            }
        }
        reload()
        return nil
    }
    
}
