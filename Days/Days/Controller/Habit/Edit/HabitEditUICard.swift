//
//  HabitEditUICard.swift
//  Days
//
//  Created by Myron on 2018/5/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditUICard: CardStandardView {
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "图标与颜色"
        container.backgroundColor = Color.white
        container.addSubview(image)
        container.addSubview(color)
        image.addTarget(self, action: #selector(image_action), for: .touchUpInside)
        color.addTarget(self, action: #selector(color_action), for: .touchUpInside)
    }
    
    override func reload() {
        super.reload()
        image.setImage(habit.image(), for: .normal)
        image.tintColor = habit.color
        color.backgroundColor = habit.color
    }
    
    override func view_bounds() {
        super.view_bounds()
        image.frame = CGRect(
            x: container.bounds.width * 0.25 - container.bounds.height * 0.5,
            y: 0,
            width: container.bounds.height,
            height: container.bounds.height
        )
        color.frame = CGRect(
            x: container.bounds.width * 0.75 - container.bounds.height * 0.5,
            y: 0,
            width: container.bounds.height,
            height: container.bounds.height
        )
    }
    
    // MARK: - Buttons
    
    let image: UIButton = Views.Button.system(image: nil)
    let color: UIButton = Views.Button.normal(title: "")
    
    @objc func image_action() {
        table.controller?.performSegue(withIdentifier: "UI", sender: true)
    }
    
    @objc func color_action() {
        table.controller?.performSegue(withIdentifier: "UI", sender: false)
    }
    
}
