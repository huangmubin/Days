//
//  BaseController.swift
//  Days
//
//  Created by Myron on 2018/6/8.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class BaseController: ViewController {
    
    private var _orientations: UIInterfaceOrientationMask?
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
        if let orient = _orientations {
            return orient
        } else {
            var orient = UIInterfaceOrientationMask.all
            let device = UIDevice.model()
            if device.contains("iPhone") {
                if device.contains("Plus") {
                    orient = .all
                } else {
                    orient = .portrait
                }
            } else if device.contains("iPod") {
                orient = .portrait
            } else if device.contains("iPad") {
                orient = .landscape
            }
            _orientations = orient
            return orient
        }
    }
    
}
