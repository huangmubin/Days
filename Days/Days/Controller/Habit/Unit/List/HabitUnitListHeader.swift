//
//  HabitUnitListHeader.swift
//  Days
//
//  Created by Myron on 2018/6/2.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitListHeader: TableViewHeaderFooter {

    // MARK: - Load
    
    override func view_load() {
        super.view_load()
        //addSubview(back_view)
        back_view.backgroundColor = Color.white
        title_label.font = Font.text.s
        title_label.textColor = Color.dark
        //addSubview(title)
    }
    
    override func view_bounds() {
        super.view_bounds()
        back_view.frame = bounds
        title_label.frame = CGRect(
            x: 10, y: 0,
            width: bounds.width - 20,
            height: bounds.height
        )
    }
    
    // MARK: - Back
    
    // let title: UILabel = Views.Label.small("", alignment: .left)
    
}
