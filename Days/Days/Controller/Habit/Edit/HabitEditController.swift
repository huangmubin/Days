//
//  HabitEditController.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditController: ViewController {

    var habit: Habit! = Habit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_cards()
    }

    // MARK: - Card Table
    
    @IBOutlet weak var table: CardTable!
    
    func load_cards() {
        table.controller = self
        
        table.cards.append(HabitEditTopCard(height: 80))
        table.cards.append(CardCalendarView(height: 80))
        table.cards.append(CardMessageView(height: 160))
        
        table.reload()
    }
    
}
