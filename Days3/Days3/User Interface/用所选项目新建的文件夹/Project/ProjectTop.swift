//
//  ProjectTop.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class ProjectTop: RootTop {

    // MARK: - Values
    
    weak var controller: ProjectController!

    // MARK: - Action
    
    override func left_action() {
        controller.view_dismiss()
    }
    
    // MARK: - Sub View
    
    let image: UIImageView = UIImageView()
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        left.tintColor = Color.black
        right.tintColor = Color.black
        left.setImage(#imageLiteral(resourceName: "ui_bar_error"), for: .normal)
        right.setImage(#imageLiteral(resourceName: "ui_bar_sure"), for: .normal)
        
        addSubview(image)
    }
    
    override func view_bounds() {
        super.view_bounds()
        image.frame = CGRect(
            x: (bounds.width - left.frame.height) / 2,
            y: edge.top,
            width: left.frame.height,
            height: left.frame.height
        )
    }
    
}
