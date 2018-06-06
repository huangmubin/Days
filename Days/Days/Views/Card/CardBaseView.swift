//
//  CardBaseView.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol HabitObjectController: class {
    var habit: Habit! { get set }
}
protocol HabitUnitObjectController: class {
    var unit: HabitUnit! { get set }
}

class CardBaseView: CardView, KeyboardDelegate, ConfirmDelegate {

    // MARK: - Value
    
    /** Edge */
    var edge: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    // MARK: - View Deploy
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(container)
        space_edge.bottom = 20
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        container.frame = CGRect(
            x: edge.left, y: edge.top,
            width: bounds.width - edge.left - edge.right,
            height: bounds.height - edge.top - edge.bottom
        )
    }
    
    // MARK: - Container
    
    let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = Color.gray.light
        return view
    }()
    
    // MARK: - Protocol Object
    
    var habit: Habit {
        if let obj = table.controller as? HabitUnitObjectController {
            return obj.unit.habit
        }
        return (table.controller as! HabitObjectController).habit
    }
    var unit_obj: HabitUnit {
        return (table.controller as! HabitUnitObjectController).unit
    }
    
    // MARK: - Sort
    
    /** The new_id */
    static var new_id: Int {
        let id = UserDefaults.standard.integer(forKey: "CardBaseView_Sort")
        UserDefaults.standard.set(id + 2, forKey: "CardBaseView_Sort")
        return id + 2
    }
    
    // MARK: - Push View Override
    
    /** Override: KeyboardDelegate  */
    func keyboard(_ board: Keyboard) -> String? { return nil }
    /** Override: ConfirmDelegate  */
    func confirm(_ view: Confirm) { }
    
}
