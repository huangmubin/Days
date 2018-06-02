//
//  HabitBoothMenuCard.swift
//  Days
//
//  Created by Myron on 2018/5/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitBoothMenuCard: CardBaseView {
    
    // MARK: - View Deploy
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(delete)
        delete.addTarget(self, action: #selector(delete_action), for: .touchUpInside)
    }
    
    // MARK: - View Bounds
    
    override func view_bounds() {
        super.view_bounds()
        delete.frame = CGRect(
            x: 20, y: 10,
            width: bounds.width - 40,
            height: bounds.height - 20
        )
    }
    
    // MARK: - delete
    
    let delete: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("删除", for: .normal)
        button.backgroundColor = Color.gray.light
        button.layer.cornerRadius = 10
        button.titleLabel?.font = Font.text.b
        button.setTitleColor(Color.red.light, for: .normal)
        return button
    }()
    
    @objc func delete_action() {
        let view = Confirm()
        view.update(title: "删除 \(habit.obj.name) 习惯以及其所有数据？")
        view.delegate = self
        view.push()
    }
    
    override func confirm(_ view: Confirm) {
        table.vc?.toSuperController(object: [Key.Habit.delete: habit])
        table.controller?.dismiss(animated: true, completion: nil)
    }
    
}
