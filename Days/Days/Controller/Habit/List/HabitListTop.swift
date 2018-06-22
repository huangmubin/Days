//
//  HabitTop.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitListTop: TopView {

    // MARK: - Link
    
    /**  */
    var controller: HabitListController?
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        title.titleLabel?.font = Font.title.s
        title.setTitle("今天", for: .normal)
        left_button.setImage(#imageLiteral(resourceName: "ui_bar_menu"), for: .normal)
        right_button.setImage(#imageLiteral(resourceName: "ui_bar_append"), for: .normal)
    }
    
    // MARK: - Actions
    
    override func title_action(_ sender: UIButton) {
        if controller!.calendar.is_showing  {
            controller?.calendar.animation(show: false)
            controller?.reload_date()
            UIView.animate(withDuration: 0.5, animations: {
                self.left_button.alpha  = 1
                self.right_button.alpha = 1
            }, completion: nil)
        } else {
            controller?.calendar.reload()
            controller?.calendar.animation(show: true)
            UIView.animate(withDuration: 0.5, animations: {
                self.left_button.alpha  = 0
                self.right_button.alpha = 0
            }, completion: nil)
        }
    }
    
    override func right_action(_ sender: UIButton) {
        self.controller?.performSegue(withIdentifier: "AppendHabit", sender: nil)
    }

//    override func view_deploy() {
//        super.view_deploy()
//        title.setTitle(
//            "习惯列表",
//            for: .normal
//        )
//    }
//
//
//    override func left_action(_ sender: UIButton) {
//        let control = self.vc as! HabitListController
//        let height: CGFloat = (control.entry_height.constant == 0 ? 90 : 0)
//        UIView.animate(withDuration: 0.25, animations: {
//            control.entry_height.constant = height
//            control.view.layoutIfNeeded()
//        })
//        /*
//         // TODO: - AppStore Delete
//         SQLite.default.log?.print_sql_text()
//         */
//    }
    
}
