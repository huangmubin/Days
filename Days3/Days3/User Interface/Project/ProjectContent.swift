//
//  ProjectContent.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class ProjectContent: RootContent {

    // MARK: - Values
    
    private var image_size: CGFloat = 60
    
    // MARK: - Action
    
    // MARK: - Sub View
    
    let lines: [UIView] = (0 ..< 3).map({
        let view = UIView()
        view.tag = $0
        view.backgroundColor = Color.gray.light
        view.layer.cornerRadius = 0.5
        return view
    })
    
    let name: UITextField = UITextField()
    
    let note: UITextView  = UITextView()
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(name)
        name.placeholder = "项目名称".language
        name.font = Font.normal
        name.textColor = Color.black
        
        addSubview(note)
        note.textColor = Color.gray.dark
        note.font = Font.small
        
        for line in lines {
            line.frame = CGRect(
                x: edge.left + image_size,
                y: 0,
                width: bounds.width - edge.left - edge.right,
                height: 1
            )
            addSubview(line)
        }
        lines[0].frame.origin.x   -= image_size
        lines[0].frame.size.width += image_size
    }
    
    override func view_bounds() {
        super.view_deploy()
        name.frame = CGRect(
            x: edge.left, y: edge.top,
            width: bounds.width - edge.left - edge.right,
            height: 40
        )
        lines[0].frame.origin.y = name.frame.maxY
        
    }

}
