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
        addSubview(back_view)
        addSubview(title)
    }
    
    override func view_bounds() {
        super.view_bounds()
        back_view.frame = bounds
        title.frame = CGRect(
            x: 10, y: 0,
            width: bounds.width - 20,
            height: bounds.height
        )
    }
    
    // MARK: - Back
    
    let back_view: UIView = {
        let view = UIView()
        view.backgroundColor = Color.white
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = Font.text.m
        label.textColor = Color.dark
        return label
    }()
    
}
