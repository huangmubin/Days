//
//  Top.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

/** Top Base View */
class TopView: View {

    // MARK: - Left
    
    @IBOutlet weak var left_button: UIButton!
    @IBAction func left_action(_ sender: UIButton) {
        self.controller()?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Right
    
    @IBOutlet weak var right_button: UIButton!
    @IBAction func right_action(_ sender: UIButton) { }
    
    // MARK: - Title
    
    @IBOutlet weak var title: UIButton! {
        didSet {
            title.titleLabel?.font = Font.title.b
            title.setTitleColor(Color.dark, for: .normal)
        }
    }

}
