//
//  HabitEditNameCard.swift
//  Days
//
//  Created by Myron on 2018/5/25.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditNameCard: CardMessageView {
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "习惯名称"
        placeholder = "新建习惯"
    }
    
    override func reload() {
        super.reload()
        update(text: habit.obj.name)
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        if let value = board.value as? String {
            if value.isEmpty {
                return "名称不得为空"
            }
        }
        return super.keyboard(board)
    }
    
}
