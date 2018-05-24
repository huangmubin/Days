//
//  HabitEditTopCard.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditTopCard: CardTopView {
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "新增习惯"
    }
    
    override func left_action(_ sender: UIButton) {
        table.controller?.dismiss(animated: true, completion: nil)
    }

}
