//
//  MainDays_Week.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit


extension MainSub {
    class Week: View {
        // MARK: - Values
        
        private let font: UIFont = Font.normal
        private let color: UIColor = Color.gray.dark
        
        // MARK: - Sub View
        
        let weeks: [UILabel] = (0 ..< 7).map({
            let view = UILabel()
            view.tag = $0
            return view
        })
        
        // MARK: - View
        
        override func view_deploy() {
            super.view_deploy()
            let texts = [
                "日".language,
                "一".language,
                "二".language,
                "三".language,
                "四".language,
                "五".language,
                "六".language,
                ]
            weeks.forEach({
                $0.text = texts[$0.tag]
                $0.font = font
                $0.textColor = color
                $0.textAlignment = .center
                $0.sizeToFit()
                addSubview($0)
            })
        }
        
        override func view_bounds() {
            super.view_deploy()
            let space = bounds.width / 7
            let x = space * 0.5
            let y = bounds.height / 2
            weeks.forEach({
                $0.center = CGPoint(
                    x: x + space * CGFloat($0.tag),
                    y: y
                )
            })
        }
    }
}

