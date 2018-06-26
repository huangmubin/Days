//
//  HabitListDays_Empty.swift
//  Days
//
//  Created by 黄穆斌 on 2018/6/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

extension HabitListDays {
    
    class Empty: View {
        
        // MARK: - Subview
        
        let date_en: UILabel = Views.Label.normal("2018年08月\n星期一", line: 0, alignment: .left)
        let date_ch: UILabel = Views.Label.normal("申茂年正月\n初三", line: 0,  alignment: .right)
        let day: UILabel = {
            let label = UILabel()
            label.text = "21"
            label.textColor = Color.dark
            label.font = UIFont(name: "PingFangSC-Light", size: 60)!
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        let sub: UILabel = Views.Label.normal("| 正月初三 |")
        
        let line: View = View(corner: 2)
        
        // MARK: - Deploy
        
        override func view_deploy() {
            super.view_deploy()
            addSubview(date_en)
            addSubview(date_ch)
            addSubview(day)
            addSubview(sub)
            addSubview(line)
            line.backgroundColor = Color.gray.dark
            
            mask = UIView()
            mask?.backgroundColor = UIColor.white
        }
        
        // MARK: - Bounds
        
        override func view_bounds() {
            super.view_bounds()
            let edge: UIEdgeInsets = UIEdgeInsets(
                top: 0, left: 0,
                bottom: 0, right: 0
            )
            
            // Date
            
            date_en.sizeToFit()
            date_en.frame.origin = CGPoint(
                x: edge.left, y: edge.top
            )
            
            date_ch.sizeToFit()
            date_ch.frame.origin = CGPoint(
                x: bounds.width - edge.right - date_ch.bounds.width,
                y: edge.top
            )
            
            // Day
            
            day.frame = bounds
            
            line.frame = CGRect(
                x: day.center.x - 30,
                y: bounds.height / 2 + 34,
                width: 60,
                height: 4
            )
            
            // Sub
            
            sub.sizeToFit()
            sub.center = CGPoint(
                x: day.center.x,
                y: bounds.height - 30
            )
            
            // Mask
            
            mask?.frame = CGRect(
                x: 0, y: 0,
                width: bounds.width,
                height: bounds.height
            )
        }
        
        // MARK: - Animation

        private let format = DateFormatter("yyyy年MM月\nEEEE")
        func update(date: Date) {
            day.text = date.day.description
            date_en.text = format.string(from: date)
            date_ch.text = "\(date.year_cn)年\n\(date.month_cn)" // \(date.month_cn)\(date.day_cn)\n
            sub.text = "| \(date.day_cn) |"
        }

    }
    
}
