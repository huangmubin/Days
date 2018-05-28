//
//  HabitEditMenuCard.swift
//  Days
//
//  Created by 黄穆斌 on 2018/5/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditMenuCard: CardStandardView {
    
    override var default_height: CGFloat {
        return edge.top + 40 + space + 60 + edge.bottom
    }
    
    // MARK: - Deploy
    
    override func reload() {
        super.reload()
        if habit.obj.is_runing {
            idle.normal_color = Color.gray.light
            idle.setTitleColor(Color.dark, for: .normal)
            idle.setTitle("闲置", for: .normal)
        } else {
            idle.normal_color = Color.dark
            idle.setTitleColor(Color.white, for: .normal)
            idle.setTitle("重启", for: .normal)
        }
    }
    
    override func view_deploy() {
        super.view_deploy()
        container.backgroundColor = Color.white
        
        container.addSubview(idle)
        container.addSubview(delete)
        
        idle.addTarget(self, action: #selector(idle_action), for: .touchUpInside)
        delete.addTarget(self, action: #selector(delete_action), for: .touchUpInside)
    }
    
    override func view_bounds() {
        super.view_bounds()
        idle.frame = CGRect(
            x: 0, y: 0,
            width: container.bounds.width / 2 - 10,
            height: container.bounds.height
        )
        delete.frame = CGRect(
            x: idle.frame.maxX + 20, y: 0,
            width: idle.frame.width,
            height: idle.frame.height
        )
    }
    
    // MARK: - Buttons
    
    let idle: Button = {
        let button = Button(type: .system)
        button.normal_color = Color.gray.light
        button.corner = 10
        button.titleLabel?.font = Font.title.b
        button.setTitleColor(Color.dark, for: .normal)
        return button
    }()
    
    @objc func idle_action() {
        let view = Confirm()
        view.id = "Idle"
        view.delegate = self
        if habit.obj.is_runing {
            view.update(title: "闲置 \(habit.obj.name)")
        } else {
            view.update(title: "重启 \(habit.obj.name)")
        }
        view.push()
    }
    
    let delete: Button = {
        let button = Button(type: .system)
        button.normal_color = Color.gray.light
        button.corner = 10
        button.setTitle("删除", for: .normal)
        button.titleLabel?.font = Font.title.b
        button.setTitleColor(Color.dark, for: .normal)
        return button
    }()
    
    @objc func delete_action() {
        let view = Confirm()
        view.id = "Delete"
        view.delegate = self
        view.update(title: "删除 \(habit.obj.name)")
        view.push()
    }
    
    override func confirm(_ view: Confirm) {
        print(view.id)
    }
    
}
