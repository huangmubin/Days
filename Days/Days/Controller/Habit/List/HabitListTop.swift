//
//  HabitTop.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitListTop: TopView {

    override func view_deploy() {
        super.view_deploy()
        title.setTitle(
            Format.MM月dd日.string(from: Date()),
            for: .normal
        )
    }
    
    override func right_action(_ sender: UIButton) {
        self.vc?.performSegue(withIdentifier: "AppendHabit", sender: nil)
    }
    
}
