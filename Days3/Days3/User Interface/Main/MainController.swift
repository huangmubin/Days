//
//  MainController.swift
//  Days3
//
//  Created by Myron on 2018/7/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MainController: RootController {

    var date: Date = Date()
    
    func update(date: Date) {
        self.date = date
    }
    
    // MARK: - Load
    
    override func loadView() {
        super.loadView()
        view.addSubview(top)
        top.controller = self
        
        view.addSubview(days)
        days.controller = self
        days.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        top.frame = CGRect(
            x: 0, y: UIApplication.shared.statusBarFrame.maxY,
            width: width, height: 60
        )
        days.frame = CGRect(
            x: 0, y: top.frame.maxY,
            width: top.frame.width,
            height: height - top.frame.maxY
        )
    }
    
    // MARK: - Views
    
    let top: MainTop = MainTop()
    
    let days: MainDays = MainDays()

}
