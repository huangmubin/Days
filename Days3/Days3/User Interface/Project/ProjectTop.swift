//
//  ProjectTop.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class ProjectTop: RootTop {
    
    // MARK: - Action
    
    override func left_action() {
        controller.view_dismiss(sender: left)
    }
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        left.tintColor = Color.black
        right.tintColor = Color.black
        left.setImage(#imageLiteral(resourceName: "ui_bar_error"), for: .normal)
        right.setImage(#imageLiteral(resourceName: "ui_bar_sure"), for: .normal)
        
        image.image = UIImage(named: "ui_main_push_0")
    }
    
    override func view_bounds() {
        super.view_bounds()
    }
    

}
