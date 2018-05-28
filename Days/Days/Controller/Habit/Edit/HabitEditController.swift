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

    // MARK: - Card Table
    
    @IBOutlet weak var table: CardTable!
    
    func load_cards() {
        table.controller = self
        
        table.cards.append(HabitEditTopCard(height: nil))
        table.cards.append(HabitEditNameCard(height: nil))
        table.cards.append(HabitEditGoalCard(height: nil))
        table.cards.append(HabitEditFrequencyCard(height: nil))
        table.cards.append(HabitEditMessageCard(height: nil))
        if habit.obj.id != 0 {
            table.cards.append(HabitEditMenuCard(height: nil))
        }
        
        table.reload()
    }
    
    // MARK: - Type Update
    
    func type_update() {
        
    }
    
}
