//
//  HabitListController.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitListController: ViewController {

    // MARK: - Top
    
    @IBOutlet weak var top: HabitListTop!
    
    @IBAction func top_entry_switch_action(_ sender: UIButton) {
        let height: CGFloat = (entry_height.constant == 0 ? 90 : 0)
        UIView.animate(withDuration: 0.25, animations: {
            self.entry_height.constant = height
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Entry
    
    @IBOutlet weak var entry: HabitListEntry!
    @IBOutlet weak var entry_height: NSLayoutConstraint!
    
    // MARK: - Table
    
    @IBOutlet weak var table: HabitListTable!
    
    
}
