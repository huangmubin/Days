//
//  HabitEditUICell.swift
//  Days
//
//  Created by Myron on 2018/5/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditUICell: UICollectionViewCell {
    
    @IBOutlet weak var value: UIButton! {
        didSet {
            value.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            value.layer.cornerRadius = 10
            value.isUserInteractionEnabled = false
        }
    }
    
}

class HabitEditUIHeader: CollectionViewReusable {
    
    override func view_load() {
        super.view_load()
        title_label.textColor = Color.dark
        title_label.font = Font.title.s
    }
    
    override func view_reload() {
        super.view_reload()
        view_bounds()
    }
    
    override func view_bounds() {
        super.view_bounds()
        title_label.frame.origin.x = 10
    }
    
}
