//
//  HabitBoothDiaryCard.swift
//  Days
//
//  Created by Myron on 2018/5/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitBoothDiaryCard: CardMessageView {
    
    /**  */
    var diary: Diary!
    
    override func view_deploy() {
        super.view_deploy()
        title.text = "日记"
        placeholder = ""
    }
    
    override func reload() {
        super.reload()
        update(text: diary.units(date: diary.habit.date.date).obj.note)
    }
    
    override func update(message: String) {
        diary.units(date: diary.habit.date.date).obj.note = message
        diary.units(date: diary.habit.date.date).obj.update()
    }
    
}
