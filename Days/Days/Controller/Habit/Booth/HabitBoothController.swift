//
//  BoothController.swift
//  Days
//
//  Created by Myron on 2018/5/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitBoothController: ViewController, HabitObjectController {
    
    var habit: Habit!
    
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
        
        table.cards.append(HabitBoothTopCard(id: "Top", height: 80))
        table.cards.append(HabitBoothCalendarCard(id: "Calendar", height: 80))
        table.cards.append(HabitBoothUnitCard(id: "Unit", height: 60))
        table.cards.append(HabitBoothChartCard(id: "Chart", height: 320))
        
        table.reload()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
