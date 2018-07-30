//
//  RootController.swift
//  Days3
//
//  Created by Myron on 2018/7/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class RootController: ViewController {

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.white
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.iPhone() {
            return .portrait
        } else {
            return .landscape
        }
    }

}
