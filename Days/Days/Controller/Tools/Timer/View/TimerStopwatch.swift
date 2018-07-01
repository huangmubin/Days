//
//  TimerStopwatch.swift
//  Days
//
//  Created by Myron on 2018/6/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TimerStopwatch: TimerView {
    
    // MARK: - Value
    
    override var start: Date {
        set { labels.start = newValue }
        get { return labels.start }
    }
    
    override var space: Int {
        set { labels.space = newValue }
        get { return labels.space }
    }
    
    override var length: Int {
        get { return Date().time1970 - labels.start.time1970 }
    }
    
    // MARK: - Subviews
    
    let labels: Label = Label()
    let layers: Layer = Layer()
    let timers: Timer = Timer()
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        labels.view(super: container)
        layers.view(super: animation)
        timers.view(super: container)
    }
    
    override func view_bounds() {
        super.view_bounds()
        let offset = -bounds.width * 0.1
        container.frame.origin.y += offset
        layers.offset = offset
        labels.view(bounds: container.bounds)
        layers.view(bounds: animation.bounds)
        timers.view(bounds: container.bounds)
    }
    
    // MARK: - Action
    
    override func run() {
//        labels.space = (timers.selector.index + 2) * 300
        labels.space = 10
        labels.start = Date()
        labels.top.text = Format.clock(labels.space)
        run_timer(milliseconds: 1000)
        
        labels.update()
        labels.bot.alpha = 1
        labels.cen.alpha = 1
        labels.top.alpha = 1
        timers.selector.alpha = 0
        timers.round.alpha = 0
    }
    
    override func animate() {
        labels.update()
    }
}

// MARK: - Sub View - Timer

extension TimerStopwatch {
    
    class Timer {
        
        let selector: iSelector = {
            let selector = iSelector(direction: .vertical)
            selector.label = UILabel()
            selector.label.font = UIFont(name: "PingFangSC-Light", size: 40)!
            selector.label.textColor = Color.dark
            selector.label.textAlignment = .center
            selector.gradien_locations = [0.15, 0.5, 0.85]
            selector.cells = 3
            selector.data = [
                "10分钟", "15分钟", "20分钟", "25分钟", "30分钟", "35分钟",
                "40分钟", "45分钟", "50分钟", "55分钟", "60分钟",
            ]
            selector.reload()
            return selector
        }()
        
        let round: UIView = {
            let view = UIView()
            view.layer.borderColor = Color.dark.cgColor
            view.layer.borderWidth = 0.5
            view.isUserInteractionEnabled = false
            view.backgroundColor = UIColor.clear
            return view
        }()
        
        func view(super view: UIView) {
            view.addSubview(selector)
            view.addSubview(round)
        }
        
        func view(bounds: CGRect) {
            selector.frame = CGRect(
                x: bounds.width * 0.1,
                y: bounds.height * 0.1,
                width: bounds.width * 0.8,
                height: bounds.height * 0.8
            )
            round.frame = CGRect(
                x: bounds.width * 0.1,
                y: bounds.height * 0.1,
                width: bounds.width * 0.8,
                height: bounds.height * 0.8
            )
            round.layer.cornerRadius = bounds.width * 0.4
        }
        
    }
    
}

// MARK: - Sub View - Labels

extension TimerStopwatch {
    
    class Label {
        
        var start: Date = Date()
        var space: Int = 0 { didSet { _space = space } }
        private var _space: Int = 0
        
        // MARK: Views
        
        let cen: UILabel = {
            let label = UILabel(frame: CGRect.zero)
            label.font = UIFont(name: "PingFangSC-Light", size: 60)!
            label.textColor = Color.dark
            label.text = "00:00"
            label.textAlignment = .center
            label.sizeToFit()
            label.alpha = 0
            return label
        }()
        
        let top: UILabel = {
            let label = UILabel(frame: CGRect.zero)
            label.font = Font.text.m
            label.textColor = Color.gray.halftone
            label.text = "00:00"
            label.textAlignment = .center
            label.sizeToFit()
            label.alpha = 0
            return label
        }()
        
        let bot: UILabel = {
            let label = UILabel(frame: CGRect.zero)
            label.font = Font.text.m
            label.textColor = Color.gray.halftone
            label.text = "00:00"
            label.textAlignment = .center
            label.sizeToFit()
            label.alpha = 0
            return label
        }()
        
        // MAKR: Deploy
        
        func view(super view: UIView) {
            view.addSubview(cen)
            view.addSubview(top)
            view.addSubview(bot)
        }
        
        func view(bounds: CGRect) {
            cen.frame = bounds
            top.frame = CGRect(
                x: 0, y: 0,
                width: bounds.width,
                height: bounds.height * 0.4
            )
            bot.frame = CGRect(
                x: 0, y: bounds.height - top.bounds.height,
                width: bounds.width,
                height: top.bounds.height
            )
        }
        
        // MARK: Update
        
        func update() {
            let now = Date()
            let run = now.time1970 - start.time1970
            cen.text = Format.clock(run)
            if _space < run {
                Impact.heavy()
                _space += space
            }
            bot.text = Format.clock(_space - run)
        }
        
    }
    
}

// MARK: - Sub View - Layers

extension TimerStopwatch {
    class Layer {
        let round: CALayer = {
            let layer = CALayer()
            layer.borderColor = Color.dark.cgColor
            layer.borderWidth = 0.5
            return layer
        }()
        
        let lines: [CAShapeLayer] = {
            var layers = [CAShapeLayer]()
            let count = 300
            for i in 0 ..< count {
                let layer = CAShapeLayer()
                layer.lineCap = kCALineCapRound
                layer.lineWidth = 1
                layer.strokeColor = Color.dark.cgColor
                layer.strokeEnd = 0
                layers.append(layer)
            }
            return layers
        }()
        
        var offset: CGFloat = 0
        
        func view(super view: UIView) {
            view.layer.addSublayer(round)
            for line in lines {
                view.layer.addSublayer(line)
            }
        }
        
        func view(bounds: CGRect) {
            let w = bounds.width * 0.8
            let space = bounds.width * 0.1
            round.frame = CGRect(
                x: space,
                y: (bounds.height - w) / 2 + offset,
                width: w,
                height: w
            )
            round.cornerRadius = w / 2
            
            let path = UIBezierPath()
            path.move(
                to: CGPoint(x: round.bounds.width / 2, y: 1)
            )
            path.addLine(
                to: CGPoint(x: round.bounds.width / 2, y: round.frame.height * 0.05)
            )
            
            let angle = (CGFloat.pi / 180) * (360 / CGFloat(lines.count))
            for (i, line) in lines.enumerated() {
                line.frame = round.frame
                line.path = path.cgPath
                line.setAffineTransform(
                    CGAffineTransform(rotationAngle: CGFloat(i) * angle)
                )
            }
        }
        
//        let animater: CAKeyframeAnimation = {
//            let key = CAKeyframeAnimation(keyPath: "strokeEnd")
//            key.values = [0, 1, 0]
//            key.duration = 2
//            key.keyTimes = [0, 0.2, 1]
//            return key
//        }()
//
//        func animate(value: Int) {
//            print(value)
//            lines[(value / 100) % lines.count].add(
//                animater,
//                forKey: "key"
//            )
//        }
    }
}
