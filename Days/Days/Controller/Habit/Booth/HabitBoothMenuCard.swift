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
        container.backgroundColor = Color.white
        
        addSubview(delete)
        delete.addTarget(self, action: #selector(delete_action), for: .touchUpInside)
        
        addSubview(edit)
        edit.addTarget(self, action: #selector(edit_action), for: .touchUpInside)
    }
    
    // MARK: - View Bounds
    
    override func view_bounds() {
        super.view_bounds()
        edit.frame = CGRect(
            x: 20, y: 10,
            width: (bounds.width - 60) / 2,
            height: bounds.height - 20
        )
        delete.frame = CGRect(
            x: edit.frame.maxX + 20,
            y: edit.frame.minY,
            width: edit.frame.width,
            height: edit.frame.height
        )
    }
    
    // MARK: - delete
    
    let delete: UIButton = Views.Button.warning(title: "删除")
    
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
    
    // MARK: - Edit
    
    let edit: UIButton = Views.Button.normal(title: "编辑")
    
    @objc func edit_action() {
        table.controller?.performSegue(withIdentifier: "HabitEdit", sender: habit)
    }
    
}
