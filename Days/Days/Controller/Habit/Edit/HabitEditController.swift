//
//  HabitEditController.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditController: ViewController, HabitObjectController {

    var habit: Habit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_cards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        table.card(id: "UI")?.reload()
    }

    // MARK: - Card Table
    
    @IBOutlet weak var table: CardTable!
    
    func load_cards() {
        table.controller = self
        
        table.cards.append(HabitEditTopCard(id: "Top", height: 80))
        table.cards.append(HabitEditNameCard(id: "Name", height: 140))
        table.cards.append(HabitEditGoalCard(id: "Goal", height: 220))
        table.cards.append(HabitEditFrequencyCard(id: "Frequency", height: 140))
        table.cards.append(HabitEditSpaceCard(id: "Space", height: 140))
        table.cards.append(HabitEditUICard(id: "UI", height: 140))
        table.cards.append(HabitEditMessageCard(id: "Message", height: 160))
        if habit.obj.id != 0 {
            table.cards.append(HabitEditMenuCard(id: "Menu", height: 160))
        }
        
        table.reload()
    }
    
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
    
}
