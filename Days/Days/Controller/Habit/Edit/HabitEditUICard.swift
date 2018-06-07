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
        title.isHidden = true
        image.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        container.backgroundColor = Color.white
        container.addSubview(image)
        container.addSubview(color)
        container.addSubview(image_label)
        container.addSubview(color_label)
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
            x: 0,
            y: 0,
            width: container.bounds.height,
            height: container.bounds.height
        )
        color.frame = CGRect(
            x: image.frame.maxX + 40,
            y: 0,
            width: container.bounds.height,
            height: container.bounds.height
        )
        image_label.center = CGPoint(
            x: image.center.x, y: image.frame.minY - 20 - space
        )
        color_label.center = CGPoint(
            x: color.center.x, y: image_label.center.y
        )
    }
    
    // MARK: - Labels
    
    let image_label: UILabel = Views.Label.title(small: "图标")
    let color_label: UILabel = Views.Label.title(small: "颜色")
    
    // MARK: - Buttons
    
    let image: UIButton = Views.Button.normal(title: "")
    let color: UIButton = Views.Button.normal(title: "")
    
    @objc func image_action() {
        table.controller?.performSegue(withIdentifier: "UI", sender: true)
    }
    
    @objc func color_action() {
        table.controller?.performSegue(withIdentifier: "UI", sender: false)
    }
    
}
