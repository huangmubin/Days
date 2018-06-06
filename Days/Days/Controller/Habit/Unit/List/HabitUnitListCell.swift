//
//  HabitUnitListCell.swift
//  Days
//
//  Created by Myron on 2018/5/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitListCell: TableViewCell {

    var unit: HabitUnit!
    
    // MARK: - Type
    
    enum ContainerType {
        case top, bottom, center, total
    }
    var type: ContainerType = .total {
        didSet {
            view_bounds()
        }
    }
    
    // MARK: - load
    
    override func view_load() {
        super.view_load()
        addSubview(container)
        addSubview(title)
        addSubview(subtitle)
        self.selectionStyle = .none
        self.clipsToBounds = true
    }
    
    override func view_reload() {
        super.view_reload()
        if unit.is_time {
            title.text = Format.time_text(second: unit.obj.length)
        } else {
            title.text = "\(unit.obj.length)次"
        }
        subtitle.text = Format.a_hh_mm.string(from: unit.obj.start)
    }
    
    // MARK: - Bounds
    
    override func view_bounds() {
        super.view_bounds()
        switch type {
        case .total:
            container.frame = CGRect(
                x: 10, y: 0,
                width: bounds.width - 20,
                height: bounds.height
            )
        case .center:
            container.frame = CGRect(
                x: 10, y: -10,
                width: bounds.width - 20,
                height: bounds.height + 20
            )
        case .top:
            container.frame = CGRect(
                x: 10, y: 0,
                width: bounds.width - 20,
                height: bounds.height + 10
            )
        case .bottom:
            container.frame = CGRect(
                x: 10, y: -10,
                width: bounds.width - 20,
                height: bounds.height + 10
            )
        }
        title.frame = CGRect(
            x: 30, y: 0,
            width: bounds.width - 50,
            height: bounds.height
        )
        subtitle.frame = title.frame
    }
    
    // MARK: - SubView
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray.light
        view.layer.cornerRadius = 10
        return view
    }()

    let title: UILabel = Views.Label.normal("")
    let subtitle: UILabel = Views.Label.small("")
    
}
