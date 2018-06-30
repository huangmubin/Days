//
//  TimerMenu.swift
//  Days
//
//  Created by Myron on 2018/6/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TimerMenu: View {
    
    // MARK: - Link
    
    /**  */
    weak var controller: TimerController?
    
    // MARK: - SubView
    
    var save: UIButton = Views.Button.normal(title: "保存")
    var start: UIButton = Views.Button.normal(title: "开始")
    
    // MARK: - Actions
    
    @objc func save_action() {
        controller?.save_action()
    }
    
    @objc func start_action() {
        controller?.start_action()
    }
    
    // MARK: - Deploy
    
    let size: CGSize = CGSize(width: 120, height: 40)
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(save)
        addSubview(start)
        
        save.alpha  = 0
        start.alpha = 0
        
        save.addTarget(self, action: #selector(save_action), for: .touchUpInside)
        start.addTarget(self, action: #selector(start_action), for: .touchUpInside)
        
        for button in [save, start] {
            button.alpha = 0
            button.layer.borderColor = Color.dark.cgColor
            button.layer.borderWidth = 0.5
            button.layer.cornerRadius = size.height / 2
            button.backgroundColor = Color.white
        }
    }
    
    override func view_bounds() {
        super.view_bounds()
        save.frame = CGRect(
            x: (bounds.width - size.width) / 2,
            y: (bounds.height - size.height - 20),
            width: size.width, height: size.height
        )
        
        start.frame = save.frame
    }
    
    /** 显示开始按钮还是保存按钮 */
    func update(start value: Bool) {
        if value {
            UIView.animate(withDuration: 0.5, animations: {
                self.start.alpha = 1
                self.save.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.start.alpha = 0
                self.save.alpha = 1
            })
        }
    }
    
}
