//
//  TimerView.swift
//  Days
//
//  Created by Myron on 2018/6/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TimerView: View {
    
    // MARK: - Value
    
    var start: Date { return Date() }
    var length: Int { return 0 }
    
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
    
    // MARK: - TimerDelegate
    
    var timer: DispatchSourceTimer?
    var flag: Int = 0
    var milliseconds: Int = 1
    
    /** Time: milliseconds */
    func run_timer(milliseconds: Int) {
        self.milliseconds = milliseconds
        timer = DispatchSource.makeTimerSource(
            flags: DispatchSource.TimerFlags(rawValue: 1),
            queue: DispatchQueue.main
        )
        timer?.schedule(
            wallDeadline: DispatchWallTime.now(),
            repeating: DispatchTimeInterval.milliseconds(milliseconds)
        )
        timer?.setEventHandler(handler: { [weak self] in
            if let w_self = self {
                w_self.flag += 1
                w_self.animate()
            }
        })
        timer?.resume()
    }
    
    func animate() { }
}
