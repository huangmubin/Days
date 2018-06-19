//
//  HabitUnitListTop.swift
//  Days
//
//  Created by Myron on 2018/6/19.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitUnitListTop: TopView {
    
    override func view_deploy() {
        super.view_deploy()
        title.setTitle(
            "打卡记录",
            for: .normal
        )
        right_button.setImage(#imageLiteral(resourceName: "but_add"), for: .normal)
    }
    
    override func right_action(_ sender: UIButton) {
        vc?.performSegue(withIdentifier: "UnitEdit", sender: nil)
    }
    
    override func left_action(_ sender: UIButton) {
        vc?.dismiss(animated: true, completion: nil)
    }
    
}
