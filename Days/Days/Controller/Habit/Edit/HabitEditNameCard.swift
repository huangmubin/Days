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
        default_height = 140
        title.text = "习惯名称"
        placeholder = "新习惯"
        text.font = Font.text.b
    }
    
    override func reload() {
        super.reload()
        update(text: habit.obj.name)
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        if (board.value as? String)?.isEmpty == true {
            return "名称不得为空"
        }
        habit.obj.name = (board.value as? String) ?? habit.obj.name
        if let top = table.card(id: "Top") as? HabitEditTopCard {
            top.update_button()
        }
        return super.keyboard(board)
    }
    
}
