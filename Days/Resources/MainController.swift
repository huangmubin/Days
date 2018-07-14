//
//  MainController.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MainController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        time.frame = CGRect(
            x: 50, y: 100,
            width: 100,
            height: 100
        )
        view.addSubview(time)
    }
    
    let time = iSelectorCombine.Time()
    
}
