//
//  MainSub.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol MainSubDateSource: class {
    func days(status date: Date) -> Bool
}

class MainSub: RootSub {
    
    // MARK: - Values
    
    weak var source: MainSubDateSource?
    
    var date: Date = Date()
    
    // MARK: - Action
    
    override func reload() {
        year.reload()
        day.reload()
    }
    
    // MARK: - Sub View
    
    let year: MainSub.Year = Year()
    let week: MainSub.Week = Week()
    let day : MainSub.Day  = Day()
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(year)
        year.view = self
        
        addSubview(week)
        
        addSubview(day)
        day.view = self
    }
    
    override func view_bounds() {
        super.view_deploy()
        year.frame = CGRect(
            x: 0, y: 0,
            width: bounds.width,
            height: App.Content.top.height
        )
        week.frame = CGRect(
            x: 10,
            y: year.frame.maxY,
            width: bounds.width - 20,
            height: 40
        )
        day.frame  = CGRect(
            x: week.frame.minX,
            y: week.frame.maxY,
            width: week.frame.width,
            height: week.frame.width / 7 * 6
        )
    }
    
}

