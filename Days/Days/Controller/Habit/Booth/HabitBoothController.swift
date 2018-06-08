//
//  BoothController.swift
//  Days
//
//  Created by Myron on 2018/5/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitBoothController: BaseController, HabitObjectController {
    
    var habit: Habit!
    var is_loaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_cards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let unit = messages.removeValue(forKey: Key.Habit.Unit.append) as? HabitUnit {
            unit.obj.id = SQLite.HabitUnit.new_id
            unit.obj.insert()
            habit.units(insert: habit.date.date, unit: unit)
            habit.chart.units(update: habit.date.date)
        }
        
        if is_loaded {
            table.reload()
        } else {            
            is_loaded = true
        }
    }
    
    // MARK: - Card Table
    
    @IBOutlet weak var table: CardTable!
    
    func load_cards() {
        table.controller = self
        
        table.cards.append(HabitBoothTopCard(id: "Top", height: 80))
        table.cards.append(HabitBoothCalendarCard(id: "Calendar", height: 80))
        table.cards.append(HabitBoothUnitCard(id: "Unit", height: 60))
        
        for chart in habit.charts {
            chart.date = habit.date
            let card = HabitBoothChartCard(id: "Chart", height: 320)
            card.chart = chart
            table.cards.append(card)
        }
        
        for event in habit.events {
            let card = HabitBoothEventCard(id: "Event", height: 180)
            card.event = event
            card.event.units_update()
            table.cards.append(card)
        }
        
        if let diary = habit.diary {
            let diary_card = HabitBoothDiaryCard(id: "Diary", height: 180)
            diary_card.diary = diary
            table.cards.append(diary_card)
        }
        
        table.cards.append(HabitBoothMenuCard(id: "Menu", height: 80))
        
        table.reload()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let unit = segue.controller as? HabitUnitEditController {
            unit.unit = sender as! HabitUnit
        }
        if let list = segue.controller as? HabitUnitListController {
            list.habit = habit
            habit.dates_reload()
        }
        if let edit = segue.controller as? HabitEditController {
            edit.habit = habit
        }
    }
    
}
