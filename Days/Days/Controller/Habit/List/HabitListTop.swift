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
        
        swipe_right = UISwipeGestureRecognizer(target: self, action: #selector(swipe_action(_:)))
        swipe_left  = UISwipeGestureRecognizer(target: self, action: #selector(swipe_action(_:)))
        swipe_left.direction = .left
        title.addGestureRecognizer(swipe_right)
        title.addGestureRecognizer(swipe_left)
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
            controller?.days.calendar.view.date = app.date
            controller?.days.reload()
            controller?.days.animation(show: true)
            UIView.animate(withDuration: 0.5, animations: {
                self.left_button.alpha  = 0
                self.right_button.alpha = 0
            }, completion: nil)
        }
    }
    
    override func left_action(_ sender: UIButton) {
        self.controller?.performSegue(withIdentifier: "Sets", sender: nil)
    }
    
    override func right_action(_ sender: UIButton) {
        self.controller?.performSegue(withIdentifier: "AppendHabit", sender: nil)
    }
    
    // MARK: - Gesture
    
    var swipe_right: UISwipeGestureRecognizer!
    var swipe_left: UISwipeGestureRecognizer!
    
    @objc func swipe_action(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            print("left")
        case .right:
            print("right")
        default: break
        }
        
        switch sender.state {
        case .ended:
            if sender === swipe_left {
                app.date = app.date.advance(.day, 1)
            } else {
                app.date = app.date.advance(.day, -1)
            }
            if controller!.days.is_showing {
                controller?.days.calendar.view.date = app.date
                controller?.days.reload()
            } else {
                controller?.collect.reloadData()
                update(date: app.date)                
            }
        default: break
        }
    }
    
}
