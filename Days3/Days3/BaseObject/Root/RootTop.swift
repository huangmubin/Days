//
//  TopView.swift
//  Days3
//
//  Created by Myron on 2018/7/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class RootTop: View {

    // MARK: - Value
    
    weak var controller: RootController!
    
    var edge: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    var left: UIButton = UIButton(type: UIButtonType.system)
    var right: UIButton = UIButton(type: UIButtonType.system)
    
    let image: UIImageView = UIImageView()
    
    // MARK: - Actions
    
    @objc func left_action() { }
    @objc func right_action() { }

    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(left)
        addSubview(right)
        left.addTarget(self, action: #selector(left_action), for: .touchUpInside)
        right.addTarget(self, action: #selector(right_action), for: .touchUpInside)
        left.isHidden = !App.is_portrait
        right.isHidden = left.isHidden
        
        addSubview(image)
    }
    
    override func view_bounds() {
        super.view_bounds()
        let size = bounds.height - edge.top - edge.bottom
        left.frame = CGRect(
            x: edge.left, y: edge.top,
            width: size, height: size
        )
        right.frame = CGRect(
            x: bounds.width - edge.right - size, y: edge.top,
            width: size, height: size
        )
        image.frame = CGRect(
            x: (bounds.width - left.frame.height) / 2,
            y: edge.top,
            width: size,
            height: size
        )
    }
    
}
