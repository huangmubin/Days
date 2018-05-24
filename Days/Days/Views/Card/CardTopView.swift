//
//  CardTopView.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class CardTopView: CardBaseView {

    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        //print("CardTopView view deploy")
        addSubview(left)
        addSubview(right)
        addSubview(title)
        addSubview(subtitle)
        
        left.addTarget(self, action: #selector(left_action(_:)), for: .touchUpInside)
        right.addTarget(self, action: #selector(right_action(_:)), for: .touchUpInside)
    }

    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        //print("update the top view bount = \(frame)")
        left.frame = CGRect(
            x: 10, y: (bounds.height - 60) / 2,
            width: 60, height: 60
        )
        right.frame = CGRect(
            x: bounds.width - 70, y: left.frame.minY,
            width: 60, height: 60
        )
        
        title.sizeToFit()
        subtitle.sizeToFit()
        let y = (bounds.height - title.frame.height - subtitle.frame.height) / 2
        title.frame = CGRect(
            x: left.frame.maxX + 8, y: y,
            width: bounds.width - 156, // 10 60 8 - 8 60 10
            height: title.frame.height
        )
        subtitle.frame = CGRect(
            x: title.frame.minX,
            y: title.frame.maxY,
            width: title.frame.width,
            height: subtitle.frame.height
        )
    }

    // MARK: - Buttons
    
    let left: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.tintColor = Color.gray.halftone
        button.setImage(#imageLiteral(resourceName: "but_back"), for: .normal)
        return button
    }()
    
    let right: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.tintColor = Color.gray.halftone
        button.setImage(#imageLiteral(resourceName: "but_sure"), for: .normal)
        return button
    }()
    
    @objc func left_action(_ sender: UIButton) { }
    @objc func right_action(_ sender: UIButton) { }
    
    // MARK: - Labels
    
    let title: UILabel = {
        let label           = UILabel()
        label.text          = "标题"
        label.font          = Font.title.b
        label.textColor     = Color.dark
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let subtitle: UILabel = {
        let label           = UILabel()
        label.text          = ""
        label.font          = Font.text.b
        label.textColor     = Color.gray.halftone
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
}
