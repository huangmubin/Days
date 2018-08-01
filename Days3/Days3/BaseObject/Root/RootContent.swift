//
//  Content.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class RootContent: View {
    
    // MARK: - Values
    
    weak var controller: RootController!
    
    var edge: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // MARK: - Action
    
    func reload() { }
    
    // MARK: - Sub View
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        self.backgroundColor = Color.white
        self.layer.cornerRadius = App.Content.corner
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = App.Content.shadow.opacity
    }
    
}
