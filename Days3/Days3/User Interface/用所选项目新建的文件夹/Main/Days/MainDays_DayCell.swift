//
//  MainDays_Cell.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit


extension MainDays {
    
    class DayCell: CollectionViewCell {
        
        var date: Date = Date()
        
        // MARK: - Sub Views
        
        let day: UILabel = UILabel(
            text: "10",
            font: Font.regular(18),
            color: Color.black,
            alignment: .center
        )
        
        // MARK: - Actions
        
        func update(month value: Bool) {
            if value {
                day.textColor = Color.black
            } else {
                day.textColor = Color.gray.halftone
            }
        }
        
        // MARK: - Load
        
        override func view_load() {
            super.view_load()
            addSubview(day)
        }
        
        override func view_reload() {
            super.view_reload()
            day.frame = bounds
        }
    }
    
    class DayCell_Select: DayCell {
        
        let select: UIView = UIView()
        
        // MARK: - Load
        
        override func update(month value: Bool) {
            super.update(month: value)
            select.isHidden = !value
            if value {
                day.textColor = Color.white
            }
        }
        
        override func view_load() {
            addSubview(select)
            day.textColor = Color.white
            select.backgroundColor = Color.black
            
            super.view_load()
        }
        
        override func view_reload() {
            super.view_reload()
            let size = min(bounds.width, bounds.height) - 4
            let x = (bounds.width - size) / 2
            let y = (bounds.height - size) / 2
            select.frame = CGRect(
                x: x, y: y,
                width: size,
                height: size
            )
            select.layer.cornerRadius = size / 2
        }
    }
    
    class DayCell_Done: DayCell {
        
        var image: UIImageView = UIImageView(image: #imageLiteral(resourceName: "ui_calendar_day_done"))
        
        override func view_load() {
            super.view_load()
            self.day.font = Font.regular(14)
            addSubview(image)
        }
        
        override func view_reload() {
            super.view_reload()
            let size = min(bounds.width, bounds.height) - 4
            let x = (bounds.width - size) / 2
            let y = (bounds.height - size) / 2
            image.frame = CGRect(
                x: x, y: y,
                width: size,
                height: size
            )
            
            day.center = CGPoint(
                x: image.frame.width / 2,
                y: image.frame.height * 0.4 + image.frame.minY
            )
        }
    }
}
