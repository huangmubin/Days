//
//  HabitUnitEditMessageCard.swift
//  Days
//
//  Created by Myron on 2018/5/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitEditMessageCard: CardMessageView {
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "留言"
        placeholder = ""
    }
    
    override func reload() {
        super.reload()
        update(text: unit_obj.obj.note)
    }
    
    override func update(message: String) {
        unit_obj.obj.note = message
    }
    
}
