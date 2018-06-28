//
//  TimerView.swift
//  Days
//
//  Created by Myron on 2018/6/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TimerView: View {
    
    // MARK: - Link
    
    weak var controller: TimerController?
    
    // MARK: - Action
    
    /** Override: Start running */
    func run() { }
    
    // MARK: - Views
    
    /**  */
    var container: UIView = UIView(frame: CGRect.zero)
    
    /** */
    var animation: UIView = UIView(frame: CGRect.zero)
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(animation)
        addSubview(container)
    }
    
    override func view_bounds() {
        super.view_bounds()
        animation.frame = bounds
        container.frame = CGRect(
            x: 0,
            y: (bounds.height - bounds.width) * 0.5,
            width: bounds.width,
            height: bounds.width
        )
    }
}
