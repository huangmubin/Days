//
//  TimerCounter.swift
//  Days
//
//  Created by Myron on 2018/6/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TimerCounter: TimerView {

    // MARK: - Value
    
    var _start: Date = Date()
    var _space: Int = 0
    var _length: Int = 0
    
    override var start: Date {
        set { _start = newValue }
        get { return _start }
    }
    override var space: Int {
        set { _space = newValue }
        get { return _space }
    }
    override var length: Int {
        set {
            _length = newValue
            length_label.text = _length.description
            smaller.alpha = _length > 0 ? 1 : 0.5
            smaller.isEnabled = _length > 0
        }
        get { return _length }
    }
    
    // MARK: - Views
    
    let selector = TimerCounter.Space()
    let length_label: UILabel = {
        let label = Views.Label.normal("0")
        label.font = label.font.withSize(60)
        return label
    }()
    let smaller = Views.Button.normal(title: "-")
    let bigger = Views.Button.normal(title: "+")
    
    override func view_deploy() {
        super.view_deploy()
        length = 0
        container.addSubview(smaller)
        container.addSubview(bigger)
        container.addSubview(length_label)
        selector.view(super: container)
        smaller.backgroundColor = Color.white
        bigger.backgroundColor = Color.white
        smaller.addTarget(self, action: #selector(smaller_action), for: .touchUpInside)
        bigger.addTarget(self, action: #selector(bigger_action), for: .touchUpInside)
    }
    
    override func view_bounds() {
        super.view_bounds()
        selector.view(bounds: container.bounds)
        length_label.frame = container.bounds
        smaller.frame = CGRect(
            x: 0, y: 0,
            width: container.bounds.width / 2,
            height: container.bounds.height
        )
        bigger.frame = CGRect(
            x: smaller.frame.maxX,
            y: smaller.frame.minY,
            width: smaller.frame.width,
            height: smaller.frame.height
        )
    }
    
    // MAKR: - Actions
    
    @objc func smaller_action() {
        length -= selector.selector.int
    }
    
    @objc func bigger_action() {
        length += selector.selector.int
    }
    
}
// MARK: - Sub View - Space

extension TimerCounter {
    
    class Space {
        
        let selector: iSelector = {
            let selector = iSelector(direction: .horizontal)
            selector.label = UILabel()
            selector.label.font = UIFont(name: "PingFangSC-Light", size: 20)!
            selector.label.textColor = Color.dark
            selector.label.textAlignment = .center
            selector.cells = 3
            selector.data = (1 ..< 100).map({"\($0)"})
            selector.reload()
            return selector
        }()
        
        let label = Views.Label.hint(small: "步长")
        
        func view(super view: UIView) {
            view.addSubview(selector)
            view.addSubview(label)
        }
        
        func view(bounds: CGRect) {
            selector.frame = CGRect(
                x: bounds.width * 0.3,
                y: 0,
                width: bounds.width * 0.4,
                height: bounds.height * 0.1
            )
            label.frame = CGRect(
                x: selector.frame.minX,
                y: selector.frame.minY - 20,
                width: selector.frame.width,
                height: 20
            )
        }
        
    }
    
}

