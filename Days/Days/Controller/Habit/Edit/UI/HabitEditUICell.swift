//
//  HabitEditUICell.swift
//  Days
//
//  Created by Myron on 2018/5/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditUICell: UICollectionViewCell {
    
    @IBOutlet weak var value: UIButton! {
        didSet {
            value.layer.cornerRadius = 10
            value.isUserInteractionEnabled = false
        }
    }
    
}
