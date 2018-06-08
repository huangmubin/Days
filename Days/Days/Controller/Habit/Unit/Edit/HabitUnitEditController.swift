//
//  HabitUnitEditController.swift
//  Days
//
//  Created by Myron on 2018/5/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitEditController: BaseController, HabitUnitObjectController {

    var unit: HabitUnit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_cards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Card Table
    
    @IBOutlet weak var table: CardTable!
    
    func load_cards() {
        table.controller = self
        
        table.cards.append(HabitUnitEditTopCard(id: "Top", height: 80))
        table.cards.append(HabitUnitEditCalendarCard(id: "Calendar", height: 80))
        if unit.is_time {
            table.cards.append(HabitUnitEditTimerCard(id: "Timer", height: unit.obj.is_sick ? 0 : 200))
        } else {
            table.cards.append(HabitUnitEditCountCard(id: "Count", height: unit.obj.is_sick ? 0 : 140))
        }
        table.cards.append(HabitUnitEditTypeCard(id: "Type", height: 140))
        table.cards.append(HabitUnitEditMessageCard(id: "Message", height: 160))
        
        table.reload()
    }
    
    func update_unit_type() {
        if unit.obj.is_sick {
            UIView.animate(withDuration: 0.25, animations: {
                self.table.card(id: "Timer")?.frame.size.height = 0
                self.table.card(id: "Count")?.frame.size.height = 0
                self.table.update_content_size()
            })
        } else {
            if unit.is_time {
                if !(table.card(id: "Timer")?.frame.height == 200) {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.table.card(id: "Timer")?.frame.size.height = 200
                        self.table.update_content_size()
                    })
                }
            } else {
                if !(table.card(id: "Count")?.frame.height == 140) {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.table.card(id: "Count")?.frame.size.height = 140
                        self.table.update_content_size()
                    })
                }
            }
        }
    }

}
