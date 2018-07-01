//
//  TimerTop.swift
//  Days
//
//  Created by Myron on 2018/6/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TimerTop: TopView {
    
    // MARK: - Link
    
    /**  */
    weak var controller: TimerController?
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        title.titleLabel?.font = Font.title.s
        left_button.setImage(#imageLiteral(resourceName: "ui_bar_right"), for: .normal)
        right_button.isHidden = true
    }
    
    // MARK: - Actions
    
    override func left_action(_ sender: UIButton) {
        TimerController.update(timer: nil)
        self.controller?.dismiss(
            animated: true,
            completion: nil
        )
    }
    
}
