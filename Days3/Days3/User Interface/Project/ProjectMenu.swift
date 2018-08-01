//
//  ProjectMenu.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class ProjectMenu: RootMenu {

    override func load_buttons() {
        buttons = [
            [
                TeletextButton(image: #imageLiteral(resourceName: "ui_menu_save"), text: "保存".language),
                TeletextButton(image: #imageLiteral(resourceName: "ui_menu_cancel"), text: "取消".language),
            ],
        ]
        lines = []
    }

}
