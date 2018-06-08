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
        if UIScreen.main.is_landscape {
            (table.card(id: "Top") as? CardTopView)?.is_suspend = true
            table_trailing.constant = BaseController.side_space
        } else {
            (table.card(id: "Top") as? CardTopView)?.is_suspend = false
            table_trailing.constant = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        table.card(id: "UI")?.reload()
        table.card(id: "Goal")?.reload()
    }

    // MARK: - Card Table
    
    @IBOutlet weak var table: CardTable!
    func load_cards() {
        table.controller = self
        
        table.cards.append(HabitEditTopCard(id: "Top", height: 80, suspend: true))
        table.cards.append(HabitEditNameCard(id: "Name", height: 140))
        table.cards.append(HabitEditFrequencyCard(id: "Frequency", height: 150))
        table.cards.append(HabitEditUICard(id: "UI", height: 140))
        table.cards.append(HabitEditGoalCard(id: "Goal", height: 150))
        //table.cards.append(HabitEditSpaceCard(id: "Space", height: 140))
        table.cards.append(HabitEditMessageCard(id: "Message", height: 160))
        if habit.obj.id != 0 {
            table.cards.append(HabitEditMenuCard(id: "Menu", height: 80))
        }
        
        table.reload()
    }
    
    // MARK: - Container View
    
    @IBOutlet weak var container: UIView!
    
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
    
    @IBOutlet weak var table_trailing: NSLayoutConstraint!
    
    // MARK: - Orientation
    
    override func orientation_will_change_action(_ rect: CGRect) {
        //let new: CGFloat = rect.width > rect.height ? BaseController.side_space : 0
        
        var new: CGFloat, y: CGFloat
        let top = table.card(id: "Top") as? CardTopView
        if rect.width > rect.height {
            top?.is_suspend = true
            new = BaseController.side_space
            y = table.contentOffset.y
        } else {
            top?.is_suspend = false
            new = 0
            y = 0
        }
        UIView.animate(withDuration: 0.25, animations: {
            top?.frame.origin.y = y
            self.table_trailing.constant = new
            self.view.layoutIfNeeded()
        })
    }
}
