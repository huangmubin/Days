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
                TeletextButton(image: #imageLiteral(resourceName: "ui_menu_project"), text: "添加项目".language),
                TeletextButton(image: #imageLiteral(resourceName: "ui_menu_habit"), text: "添加习惯".language),
                ],
            [
                TeletextButton(image: #imageLiteral(resourceName: "ui_menu_timer"), text: "定时器".language),
                TeletextButton(image: #imageLiteral(resourceName: "ui_menu_counter"), text: "计步器".language),
                ],
            [
                TeletextButton(image: #imageLiteral(resourceName: "ui_menu_projects"), text: "项目列表".language),
                TeletextButton(image: #imageLiteral(resourceName: "ui_menu_habits"), text: "习惯列表".language),
                ],
            [
                TeletextButton(image: #imageLiteral(resourceName: "ui_menu_deploy"), text: "应用配置".language),
                ],
        ]
        lines = [UIView(), UIView(), UIView()]
    }

}
