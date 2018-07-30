//
//  MainContent_Cell.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

// MARK: - Cell

extension MainContent {
    class Cell: TableViewCell {
        
        let edge: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let time: UILabel  = UILabel()
        let from: UILabel  = UILabel()
        let title: UILabel = UILabel()
        let note: UILabel  = UILabel()
        
        let status: Status = Status()
        
        override func view_load() {
            super.view_load()
            selectionStyle = .none
            
            addSubview(time)
            time.textColor = Color.gray.halftone
            time.font = Font.small
            time.text = "04:00"
            
            addSubview(from)
            from.textColor = time.textColor
            from.font = time.font
            from.text = "父视图 > ... > xxx 的内容"
            
            addSubview(title)
            title.textColor = Color.black
            title.font = Font.normal
            title.text = "xxxx 内容的子代办事项"
            title.numberOfLines = 0
            
            addSubview(note)
            note.textColor = Color.gray.dark
            note.font = Font.regular(14)
            note.text = "测试的内容"
            note.numberOfLines = 0
            
            addSubview(status)
            status.cell = self
        }
        
        override func view_reload() {
            super.view_reload()
            let status_size: CGFloat = 60
            status.frame = CGRect(
                x: bounds.width - edge.right - status_size,
                y: edge.top,
                width: status_size,
                height: status_size
            )
            
            time.sizeToFit()
            time.frame.origin = CGPoint(x: edge.left, y: edge.top)
            
            from.sizeToFit()
            from.frame = CGRect(
                x: edge.left + 40, y: time.frame.minY,
                width: status.frame.minX - edge.left - 48,
                height: from.bounds.height
            )
            
            let label_width = status.frame.minX - 10 - edge.left
            title.frame.size.width = label_width
            note.frame.size.width = label_width
            
            title.sizeToFit()
            title.frame = CGRect(
                x: edge.left,
                y: from.frame.maxY,
                width: label_width,
                height: title.bounds.height
            )
            
            note.sizeToFit()
            note.frame = CGRect(
                x: edge.left,
                y: title.frame.maxY,
                width: label_width,
                height: note.bounds.height
            )
        }
        
        static let cell = MainContent.Cell(frame: UIScreen.main.bounds)
    }
    
    class Header: TableViewHeaderFooter {
        
        let title: UILabel = UILabel(text: "已完成".language)
        
        override func view_load() {
            super.view_load()
            addSubview(title)
            title.font = Font.normal
            title.textColor = Color.gray.dark
            title.sizeToFit()
        }
        
        override func view_reload() {
            super.view_reload()
            title.center = CGPoint(
                x: bounds.width / 2,
                y: bounds.height / 2 + 10
            )
        }
    }
}


