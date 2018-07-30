//
//  MainContent_Status.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

// MARK: - Status

extension MainContent {
    class Status: View, CAAnimationDelegate {
        
        // MARK: - Values
        
        weak var cell: MainContent.Cell!
        var value: CGFloat = 0
        
        // MARK: - Action
        
        func update(value: CGFloat, animtion: Bool) {
            guard animtion else {
                view_bounds();
                return
            }
            
            let old = self.value > 1 ? 1 : (self.value < 0 ? -1 : 0)
            let new = value > 1 ? 1 : (value < 0 ? -1 : 0)
            self.value = value
            switch (old, new) {
            case (0, 0):
                info.text = String(format: "%.0f%%", value * 100)
                value_to_value()
            case (0, -1):
                value_to_close()
            case (0, 1):
                value_to_done()
            case (_, 0):
                info.text = String(format: "%.0f%%", value * 100)
                done_to_value()
            default: break
            }
        }
        
        // MARK: - Animation
        
        private func value_to_value() {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            layers.progress.strokeEnd = value
            CATransaction.commit()
        }
        
        private func value_to(end: CGFloat, completion: ((Bool) -> Void)?) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            layers.progress.strokeEnd = end
            CATransaction.setCompletionBlock({
                self.layers.progress.opacity = 0
                self.layers.center.frame = CGRect(
                    x: self.bounds.width / 2, y: self.bounds.height / 2,
                    width: 0, height: 0
                )
                UIView.animate(withDuration: 0.25, animations: {
                    self.info.alpha = 0
                }, completion: completion)
            })
            CATransaction.commit()
        }
        
        private func value_to_close() {
            value_to(end: 0, completion: { _ in
                self.mask?.frame = self.bounds
                
                self.layers.done.strokeStart = 0.5
                self.layers.done.strokeEnd   = 0.5
                self.layers.close.strokeStart = 0.5
                self.layers.close.strokeEnd   = 0.5
                
                self.path_close()
                
                self.layers.done.opacity  = 1
                self.layers.close.opacity = 1
                
                for (key, value) in [("strokeStart", 0.2), ("strokeEnd", 0.8)] {
                    for layer in [self.layers.done, self.layers.close] {
                        let spring = CASpringAnimation(keyPath: key)
                        spring.toValue = value
                        spring.stiffness = 60
                        spring.duration = spring.settlingDuration
                        spring.isRemovedOnCompletion = false
                        spring.fillMode = kCAFillModeForwards
                        layer.add(spring, forKey: key)
                    }
                }
                
                UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveLinear, animations: {
                    self.mask?.frame = CGRect(
                        x: self.edge, y: self.edge,
                        width: self.bounds.width - self.edge * 2,
                        height: self.bounds.height - self.edge * 2
                    )
                }, completion: nil)
            })
        }
        
        private func value_to_done() {
            value_to(end: 1, completion: { _ in
                self.mask?.frame = self.bounds
                
                self.layers.done.strokeStart = 0
                self.layers.done.strokeEnd = 0
                
                self.path_done()
                
                self.layers.done.opacity = 1
                self.layers.close.opacity = 0
                
                let end = CASpringAnimation(keyPath: "strokeEnd")
                end.toValue = 0.9
                end.stiffness = 80
                end.duration = end.settlingDuration
                end.isRemovedOnCompletion = false
                end.fillMode = kCAFillModeForwards
                self.layers.done.add(end, forKey: "strokeEnd")
                
                
                let start = CASpringAnimation(keyPath: "strokeStart")
                start.toValue = 0.32
                start.duration = start.settlingDuration
                start.isRemovedOnCompletion = false
                start.fillMode = kCAFillModeForwards
                self.layers.done.add(start, forKey: "strokeStart")
                
                UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveLinear, animations: {
                    self.mask?.frame = CGRect(
                        x: self.edge, y: self.edge,
                        width: self.bounds.width - self.edge * 2,
                        height: self.bounds.height - self.edge * 2
                    )
                }, completion: nil)
            })
        }
        
        private func done_to_value() {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            layers.progress.strokeEnd = 0
            layers.close.strokeStart = 0.5
            layers.close.strokeEnd = 0.5
            layers.done.strokeStart = 0.5
            layers.done.strokeEnd = 0.5
            CATransaction.setCompletionBlock({
                self.layers.close.opacity = 0
                self.layers.done.opacity = 0
                self.layers.progress.opacity = 1
                self.layers.center.frame = CGRect(
                    x: self.layers.back.frame.minX + self.line,
                    y: self.layers.back.frame.minY + self.line,
                    width: self.layers.back.frame.width - self.line * 2,
                    height: self.layers.back.frame.height - self.line * 2
                )
                UIView.animate(withDuration: 0.25, animations: {
                    self.info.alpha = 1
                }, completion: { _ in
                    self.layers.progress.strokeEnd = self.value
                })
            })
            CATransaction.commit()
        }
        
        // MARK: - Sub View
        
        class Layer {
            let back: CALayer = CALayer()
            let center: CALayer = CALayer()
            let progress: CAShapeLayer = CAShapeLayer()
            let done: CAShapeLayer = CAShapeLayer()
            let close: CAShapeLayer = CAShapeLayer()
        }
        private let layers: Layer = Layer()
        
        private let info: UILabel = UILabel()
        
        // MARK: - View
        
        override func view_deploy() {
            super.view_deploy()
            mask = UIView()
            mask?.frame = bounds
            mask?.backgroundColor = UIColor.black
            
            layer.addSublayer(layers.back)
            layer.addSublayer(layers.center)
            layer.addSublayer(layers.progress)
            layer.addSublayer(layers.done)
            layer.addSublayer(layers.close)
            
            layers.back.backgroundColor     = Color.gray.light.cgColor
            layers.center.backgroundColor   = Color.white.cgColor
            
            layers.progress.fillColor       = nil
            layers.progress.lineCap         = kCALineCapRound
            layers.progress.strokeColor     = Color.black.cgColor
            
            layers.done.fillColor           = nil
            layers.done.strokeColor         = Color.black.cgColor
            
            layers.close.fillColor          = nil
            layers.close.strokeColor        = Color.black.cgColor
            
            self.addSubview(info)
            info.textColor = Color.black
            info.textAlignment = .center
            info.font = Font.regular(10)
            
            deploy_gesture()
        }
        
        private var edge: CGFloat = 0
        private var line: CGFloat = 0
        override func view_bounds() {
            super.view_deploy()
            edge = bounds.width * 0.1
            line = bounds.width * 0.16
            
            mask?.frame = CGRect(
                x: edge, y: edge,
                width: bounds.width - edge * 2,
                height: bounds.height - edge * 2
            )
            mask?.layer.cornerRadius = mask!.frame.width / 2
            
            layers.back.frame = CGRect(
                x: edge, y: edge,
                width: bounds.width - edge * 2,
                height: bounds.height - edge * 2
            )
            layers.back.cornerRadius = layers.back.frame.width / 2
            
            layers.progress.frame = layers.back.frame
            layers.progress.lineWidth = line
            path_progress()
            layers.progress.strokeEnd = value
            
            layers.done.frame = bounds
            layers.close.frame = bounds
            
            layers.done.lineWidth = line * 0.8
            layers.close.lineWidth = line * 0.8
            
            if value > 1 {
                view_bounds_done(edge: edge)
            } else if value < 0 {
                view_bounds_close(edge: edge)
            } else {
                view_bounds_doing(edge: edge)
            }
        }
        
        private func path_progress() {
            layers.progress.path = UIBezierPath(ovalIn: CGRect(
                x: line / 2, y: line / 2,
                width: layers.progress.frame.width - line,
                height: layers.progress.frame.height - line
            )).cgPath
        }
        
        private func path_done() {
            let path = UIBezierPath()
            let offset_x: CGFloat = bounds.width * -0.06
            let offset_y: CGFloat = bounds.height * 0.12
            path.move(to: CGPoint(
                x: offset_x,
                y: offset_y
            ))
            path.addLine(to: CGPoint(
                x: bounds.width * 0.5 + offset_x,
                y: bounds.height * 0.5 + offset_y
            ))
            path.addLine(to: CGPoint(
                x: bounds.width * 1 + offset_x,
                y: offset_y
            ))
            layers.done.path = path.cgPath
        }
        
        private func path_close() {
            let d_path = UIBezierPath()
            d_path.move(to: CGPoint(
                x: 0, y: 0
            ))
            d_path.addLine(to: CGPoint(
                x: bounds.width, y: bounds.height
            ))
            layers.done.path = d_path.cgPath
            
            let c_path = UIBezierPath()
            c_path.move(to: CGPoint(
                x: 0, y: bounds.height
            ))
            c_path.addLine(to: CGPoint(
                x: bounds.width, y: 0
            ))
            layers.close.path = c_path.cgPath
        }
        
        private func view_bounds_doing(edge: CGFloat) {
            layers.center.frame = CGRect(
                x: layers.back.frame.minX + line,
                y: layers.back.frame.minY + line,
                width: layers.back.frame.width - line * 2,
                height: layers.back.frame.height - line * 2
            )
            layers.center.cornerRadius = layers.center.frame.width / 2
            
            layers.progress.opacity = 1
            layers.progress.strokeEnd = value
            
            layers.done.opacity = 0
            layers.close.opacity = 0
            
            info.alpha = 1
            info.font = info.font.withSize((bounds.width - (edge + line) * 2.2) / 2 - 2)
            info.text = String(format: "%.0f%%", value * 100)
            info.frame = bounds
        }
        
        private func view_bounds_done(edge: CGFloat) {
            layers.center.frame = CGRect(
                x: layers.back.frame.midX,
                y: layers.back.frame.midY,
                width: 0, height: 0
            )
            
            layers.progress.opacity = 0
            
            layers.done.opacity = 1
            layers.close.opacity = 0
            
            path_done()
            
            layers.done.strokeStart = 0.32
            layers.done.strokeEnd = 0.9
            
            info.alpha = 0
        }
        
        private func view_bounds_close(edge: CGFloat) {
            layers.center.frame = CGRect(
                x: layers.back.frame.midX,
                y: layers.back.frame.midY,
                width: 0, height: 0
            )
            
            layers.progress.opacity = 0
            
            layers.done.opacity = 1
            layers.close.opacity = 1
            
            path_close()
            
            layers.done.strokeStart = 0.2
            layers.done.strokeEnd = 0.8
            
            layers.close.strokeStart = 0.2
            layers.close.strokeEnd = 0.8
            
            info.alpha = 0
        }
        
        // MARK: - Gesture
        
        var tap: UITapGestureRecognizer!
        var long: UILongPressGestureRecognizer!
        
        private func deploy_gesture() {
            tap = UITapGestureRecognizer(target: self, action: #selector(tap_action))
            long = UILongPressGestureRecognizer(target: self, action: #selector(long_action))
            
            tap.require(toFail: long)
            
            addGestureRecognizer(tap)
            addGestureRecognizer(long)
        }
        
        @objc func tap_action() {
            print("tap_action \(cell.index.section) - \(cell.index.row)")
        }
        
        @objc func long_action() {
            print("long_action \(cell.index.section) - \(cell.index.row)")
        }
    }
}

