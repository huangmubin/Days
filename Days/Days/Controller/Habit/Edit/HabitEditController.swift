//
//  HabitEditController.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditController: BaseController, HabitObjectController {

    var habit: Habit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_cards()
        view_bounds(rect: UIScreen.main.bounds, animate: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        table.card(id: "UI")?.reload()
        table.card(id: "Goal")?.reload()
        table.card(id: "Call")?.reload()
    }

    // MARK: - Card Table
    
    @IBOutlet weak var table: CardTable!
    func load_cards() {
        table.controller = self
        
        table.cards.append(HabitEditTopCard(id: "Top", height: 60, suspend: true))
        table.cards.append(HabitEditNameCard(id: "Name", height: 120))
        table.cards.append(HabitEditFrequencyCard(id: "Frequency", height: 130))
        table.cards.append(HabitEditUICard(id: "UI", height: 120))
        table.cards.append(HabitEditGoalCard(id: "Goal", height: 130))
        //table.cards.append(HabitEditSpaceCard(id: "Space", height: 140))
        table.cards.append(HabitEditMessageCard(id: "Message", height: 140))
        table.cards.append(HabitEditCallCard(id: "Call", height: 50))
        if habit.obj.id != 0 {
            table.cards.append(HabitEditMenuCard(id: "Menu", height: 60))
        }
        
        table.reload()
    }
    
    func table_shadow(_ open: Bool) {
        shadow_view.layer.shadowOpacity = open ? 1 : 0
        shadow_view.layer.cornerRadius = open ? 20 : 0
        shadow_view.layer.shadowOffset.height = 3
    }
    
    // MARK: - Container View
    
    @IBOutlet weak var container: UIView!
    
    // MARK: - Shadow View
    
    @IBOutlet weak var shadow_view: UIView!
    
    // MARK: - Type Update
    
    func type_update() {
        table.card(id: "Frequency")?.reload()
        table.card(id: "Space")?.reload()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ui = segue.controller as? HabitEditUIController {
            ui.habit = habit
            ui.is_image = sender as! Bool
        }
    }
    
    // MARK: - Layout
    
    @IBOutlet weak var table_leading: NSLayoutConstraint!
    @IBOutlet weak var table_trailing: NSLayoutConstraint!
    @IBOutlet weak var table_bottom: NSLayoutConstraint!
    
    // MARK: - Orientation
    
    override func orientation_will_change_action(_ rect: CGRect) {
        view_bounds(rect: rect, animate: true)
    }
    
    func view_bounds(rect: CGRect, animate: Bool) {
        var new: CGFloat, y: CGFloat, open: Bool, bottom: CGFloat
        let top = table.card(id: "Top") as? CardTopView
        if rect.width > rect.height {
            top?.is_suspend = true
            new = BaseController.side_center
            y = table.contentOffset.y
            bottom = 10
            open = true
        } else {
            top?.is_suspend = false
            new = 0
            y = 0
            open = false
            bottom = 0
        }
        
        UIView.animate(withDuration: animate ? 0.25 : 0, animations: {
            top?.frame.origin.y = y
            //self.table_trailing.constant = new
            self.table_leading.constant = new
            self.table_trailing.constant = new
            self.table_bottom.constant = bottom
            
            self.shadow_view.layer.shadowOpacity = open ? 0.4 : 0
            self.shadow_view.layer.cornerRadius = open ? 20 : 0
            self.shadow_view.layer.shadowOffset.height = 3
            
            self.view.layoutIfNeeded()
        })
    }
}
