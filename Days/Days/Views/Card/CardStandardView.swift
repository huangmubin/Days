//
//  CardStandardView.swift
//  Days
//
//  Created by Myron on 2018/5/25.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class CardStandardView: CardBaseView {
    
    // MARK: - Value
    
    /** Space title to container */
    var space: CGFloat = 20
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(title)
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        title.frame = CGRect(
            x: edge.left,
            y: edge.top,
            width: bounds.width - edge.left - edge.right,
            height: 40
        )
        
        container.frame = CGRect(
            x: edge.left,
            y: title.frame.maxY + space,
            width: title.frame.width,
            height: bounds.height - title.frame.maxY - space - edge.bottom
        )
    }
    
    // MARK: - Title
    
    let title: UILabel = Views.Label.title("标题", alignment: .left)
    
}
