//
//  MainMenu.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MainMenu: View {
    
    // MARK: - Values
    
    weak var controller: MainController!
    
    // MARK: - Action
    
    func update(column col: Int) -> CGFloat {
        switch col {
        case 2:
            return 500
        default:
            return UIScreen.main.bounds.height
        }
    }
    
    // MARK: - Sub View
    
    let scroll: UIScrollView = UIScrollView()
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        self.backgroundColor = UIColor.red
    }
    
    override func view_bounds() {
        super.view_deploy()
    }
    
    
}
