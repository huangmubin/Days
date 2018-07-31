//
//  ProjectController.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class ProjectController: RootController {

    // MARK: - Load
    
    override func view_load() {
        super.view_load()
        top     = ProjectTop()
        sub     = ProjectSub()
        content = ProjectContent()
        menu    = ProjectMenu()
    }
    
    // MARK: - View
    
    // MARK: - Action
    
}
