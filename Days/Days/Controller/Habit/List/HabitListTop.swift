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
            "习惯列表",
            for: .normal
        )
    }
    
    override func right_action(_ sender: UIButton) {
        self.vc?.performSegue(withIdentifier: "AppendHabit", sender: nil)
    }
    
    override func left_action(_ sender: UIButton) {
        let control = self.vc as! HabitListController
        let height: CGFloat = (control.entry_height.constant == 0 ? 90 : 0)
        UIView.animate(withDuration: 0.25, animations: {
            control.entry_height.constant = height
            control.view.layoutIfNeeded()
        })
        /*
         // TODO: - AppStore Delete
         SQLite.default.log?.print_sql_text()
         */
    }
    
}
