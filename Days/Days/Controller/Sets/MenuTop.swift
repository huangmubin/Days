//
//  SetsTop.swift
//  Days
//
//  Created by 黄穆斌 on 2018/7/25.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MenuTop: TopView {

    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        //title.titleLabel?.font = Font.title.s
        title.setTitle("菜单", for: .normal)
        left_button.setImage(#imageLiteral(resourceName: "ui_bar_right"), for: .normal)
        right_button.setImage(#imageLiteral(resourceName: "ui_bar_append"), for: .normal)
    }
    
}
