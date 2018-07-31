//
//  MainController.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MainController: RootController {

    // MARK: - Load
    
    override func view_load() {
        super.view_load()
        top     = MainTop()
        sub     = MainSub()
        content = MainContent()
        menu    = MainMenu()
    }
    
    // MARK: - View
    
    // MARK: - Action
    

}
