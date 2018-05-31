//
//  HabitEditMessageCard.swift
//  Days
//
//  Created by 黄穆斌 on 2018/5/26.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditMessageCard: CardMessageView {
    
    override func view_deploy() {
        super.view_deploy()
        default_height = 160
        title.text = "给自己的口号"
        placeholder = "人生塑造于生活。"
    }
    
    override func reload() {
        super.reload()
        update(text: habit.obj.note)
    }
    
    override func update(message: String) {
        habit.obj.note = message
    }
    
}
