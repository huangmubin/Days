//
//  HabitBoothTopCard.swift
//  Days
//
//  Created by Myron on 2018/5/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitBoothTopCard: CardTopView {
    
    override func reload() {
        super.reload()
        space_edge.bottom = 0
        right.isHidden = true
        title.text = habit.obj.name
    }
    
    override func left_action(_ sender: UIButton) {
        app.date = Date()
        table.controller?.dismiss(animated: true, completion: nil)
    }
    
    override func right_action(_ sender: UIButton) {
        app.date = Date()
        table.controller?.dismiss(animated: true, completion: nil)
    }
    
}
