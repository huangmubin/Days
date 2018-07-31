//
//  MainDays_Year.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

extension MainSub {
    class Year: View {
        
        // MARK: - Values
        
        weak var view: MainSub!
        private let format = DateFormatter("yyyy年MM月".language)
        private var date: Date = Date()
        
        // MARK: - Action
        
        func reload() {
            years.forEach({
                if $0.tag == 0 {
                    $0.setTitle(
                        format.string(from: date),
                        for: .normal
                    )
                } else {
                    $0.setTitle(
                        "\(date.year + $0.tag)",
                        for: .normal
                    )
                }
            })
        }
        
        func update(_ date: Date) {
            self.date = date
            reload()
        }
        
        @objc func year_change(_ sender: UIButton) {
            if sender.tag == 0 {
                view.controller.view_sub(show: false)
            } else {
                date = date.advance(.year, sender.tag)
                view.day.update(date)
                reload()
            }
        }
        
        // MARK: - Sub View
        
        let years: [UIButton] = (0 ..< 3).map({
            let view = UIButton()
            view.tag = $0 - 1
            return view
        })
        
        // MARK: - View
        
        override func view_deploy() {
            super.view_deploy()
            years.forEach({
                $0.setTitleColor($0.tag == 0 ? Color.black : Color.gray.dark, for: .normal)
                $0.titleLabel?.font = $0.tag == 0 ? Font.normal : Font.small
                $0.addTarget(self, action: #selector(year_change(_:)), for: .touchUpInside)
                addSubview($0)
            })
        }
        
        override func view_bounds() {
            super.view_deploy()
            let width = bounds.width * 0.2
            years[0].frame = CGRect(
                x: 0, y: 0,
                width: width,
                height: bounds.height
            )
            years[2].frame = CGRect(
                x: bounds.width - width, y: 0,
                width: width,
                height: bounds.height
            )
            years[1].frame = CGRect(
                x: years[0].frame.maxX,
                y: 0,
                width: years[2].frame.minX - years[0].frame.maxX,
                height: bounds.height
            )
        }
    }
}


