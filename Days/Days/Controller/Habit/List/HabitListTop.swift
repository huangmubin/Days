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
    
    func update(date: Date) {
        title.setTitle(
            Format.day_month(date),
            for: .normal
        )
    }
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        //title.titleLabel?.font = Font.title.s
        title.setTitle("今天", for: .normal)
        left_button.setImage(#imageLiteral(resourceName: "ui_bar_menu"), for: .normal)
        right_button.setImage(#imageLiteral(resourceName: "ui_bar_append"), for: .normal)
        
        left_button.isHidden = true
    }
    
    // MARK: - Actions
    
    override func title_action(_ sender: UIButton) {
        if controller!.days.is_showing  {
            controller?.days.animation(show: false)
            controller?.reload_date()
            UIView.animate(withDuration: 0.5, animations: {
                self.left_button.alpha  = 1
                self.right_button.alpha = 1
            }, completion: nil)
        } else {
            controller?.days.reload()
            controller?.days.animation(show: true)
            UIView.animate(withDuration: 0.5, animations: {
                self.left_button.alpha  = 0
                self.right_button.alpha = 0
            }, completion: nil)
        }
    }
    
    override func right_action(_ sender: UIButton) {
        self.controller?.performSegue(withIdentifier: "AppendHabit", sender: nil)
    }
    
}
