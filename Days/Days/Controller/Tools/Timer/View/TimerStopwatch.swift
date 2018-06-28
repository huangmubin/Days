//
//  TimerStopwatch.swift
//  Days
//
//  Created by Myron on 2018/6/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TimerStopwatch: TimerView {
    
    // MARK: - Subviews
    
    let labels: Label = Label()
    
    // MARK: - Animation Layers
    
    let layers: Layer = Layer()
    
    // MARK: - Deploy
    
    override func view_deploy() {
        super.view_deploy()
        labels.view(super: container)
        layers.view(super: animation)
    }
    
    override func view_bounds() {
        super.view_bounds()
        let offset = -bounds.width * 0.1
        container.frame.origin.y += offset
        layers.offset = offset
        labels.view(bounds: container.bounds)
        layers.view(bounds: animation.bounds)
    }
    
}

// MARK: - Sub View - Labels

extension TimerStopwatch {
    
    class Label {
        
        let cen: UILabel = {
            let label = UILabel(frame: CGRect.zero)
            label.font = UIFont(name: "PingFangSC-Regular", size: 80)!
            label.textColor = Color.dark
            label.text = "00:00"
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        
        let top: UILabel = {
            let label = UILabel(frame: CGRect.zero)
            label.font = Font.text.m
            label.textColor = Color.gray.halftone
            label.text = "00:00"
            label.textAlignment = .center
            label.sizeToFit()
            //label.alpha = 0
            return label
        }()
        
        let bot: UILabel = {
            let label = UILabel(frame: CGRect.zero)
            label.font = Font.text.m
            label.textColor = Color.gray.halftone
            label.text = "00:00"
            label.textAlignment = .center
            label.sizeToFit()
            //label.alpha = 0
            return label
        }()
        
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
            let count = 24
            let angle: CGFloat = 360 / CGFloat(count)
            for i in 0 ..< count {
                let layer = CAShapeLayer()
                layer.borderColor = Color.dark.cgColor
                layer.lineCap = kCALineCapRound
                layer.lineWidth = 2
                layer.setAffineTransform(
                    CGAffineTransform(rotationAngle: CGFloat(i) * angle)
                )
                layers.append(layer)
            }
            return layers
        }()
        
        var offset: CGFloat = 0
        
        func view(super view: UIView) {
            view.layer.addSublayer(round)
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
                to: CGPoint(x: bounds.width / 2, y: round.frame.minY)
            )
            path.addLine(
                to: CGPoint(x: bounds.width / 2, y: round.frame.maxY)
            )
            for layer in lines {
                layer.path = path.cgPath
            }
        }
    }
}
