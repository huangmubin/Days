//
//  CardStandardEditView.swift
//  Days
//
//  Created by Myron on 2018/6/7.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class CardStandardEditView: CardStandardView {
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        // Self
        title.text = "频率"
        container.backgroundColor = Color.white
        
        // Sub
        container.addSubview(normal)
        container.addSubview(edit)
        container.addSubview(info)
        container.addSubview(info_sub)
        container.addSubview(info_edit)
        
        edit.backgroundColor = UIColor.clear
        
        normal.addTarget(self, action: #selector(normal_action), for: .touchUpInside)
        edit.addTarget(self, action: #selector(edit_action), for: .touchUpInside)
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        normal.frame = CGRect(
            x: 0, y: 0,
            width: container.frame.width,
            height: container.frame.height - 10
        )
        
        info_edit.frame = CGRect(
            x: container.bounds.width * 0.5,
            y: container.bounds.height - 10,
            width: container.bounds.width * 0.5,
            height: 20
        )
        edit.frame = CGRect(
            x: container.bounds.width * 0.7,
            y: container.bounds.height * 0.5,
            width: container.bounds.width * 0.3,
            height: container.bounds.height * 0.5 + 10
        )
        
        info.sizeToFit()
        info_sub.sizeToFit()
        info.center = CGPoint(
            x: normal.center.x - info_sub.bounds.width / 2 - 4,
            y: normal.center.y
        )
        info_sub.center = CGPoint(
            x: normal.center.x + info.bounds.width / 2 + 4,
            y: info.center.y
        )
    }
    
    // MARK: - Normal Action
    
    /** Normal button, at the container space */
    let normal: UIButton = Views.Button.normal(title: "")
    
    @objc func normal_action() {
        let board = Keyboard()
        board.delegate = self
        board.id = "normal"
        normal_keyboard(board)
        board.push()
    }
    
    /** Override normal keyboard */
    func normal_keyboard(_ board: Keyboard) {}
    
    // MARK: Normal label
    
    let info: UILabel = Views.Label.normal("10")
    let info_sub: UILabel = Views.Label.hint("分钟")
    let info_edit: UILabel = Views.Label.hint("分钟", alignment: .right)
    
    // MARK: - Edit Action
    
    let edit: UIButton = Views.Button.normal(title: "")
    
    @objc func edit_action() {
        let board = Keyboard()
        board.delegate = self
        board.id = "edit"
        edit_keyboard(board)
        board.push()
    }
    
    /** Override normal keyboard */
    func edit_keyboard(_ board: Keyboard) {}
    
}
