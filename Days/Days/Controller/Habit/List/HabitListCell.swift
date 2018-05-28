//
//  HabitListCell.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitListCell: TableViewCell {
    
    // MARK: - View Deploy
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(show)
        addSubview(progress)
        
        progress.mask?.layer.cornerRadius = 0
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(pan_action(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)
        
        progress.value = 0.2
    }
    
    // MARK: - View Bounds
    
    override func view_bounds() {
        super.view_bounds()
        show.frame = CGRect(
            x: 10, y: 10,
            width: bounds.width - 20,
            height: bounds.height - 20
        )
        progress.frame = show.frame
    }
    
    // MARK: - Views
    
    let show: Container = {
        let view = Container()
        view.update(type: true)
        return view
    }()
    
    let progress: Container = {
        let view = Container()
        view.update(type: false)
        return view
    }()
    
    // MARK: - Pan
    
    // MARK: - Gesture
    
    var pan: UIPanGestureRecognizer!
    var pan_start: CGFloat = 0
    @objc func pan_action(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            pan_start = 10 + show.mask!.bounds.width
        case .ended:
            if sender.translation(in: self).x + pan_start < self.frame.midX {
                UIView.animate(withDuration: 0.25, animations: {
                    self.show.value = (self.show.size + 20) / self.show.frame.width
                    self.progress.frame.size.width = self.show.mask!.bounds.width
                })
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.show.value = 1
                    self.progress.frame.size.width = self.show.mask!.bounds.width
                })
            }
        default:
            let x = sender.translation(in: self).x + pan_start - show.frame.minX
            show.value = x / show.frame.width
            progress.frame.size.width = show.mask!.bounds.width
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === pan {
            let offset = pan.velocity(in: self)
            return abs(offset.x) > abs(offset.y)
        }
        return false
    }
    
}

// MARK: - Container

extension HabitListCell {
    
    class Container: View {
        
        /** Progress Value */
        var value: CGFloat = 1 {
            didSet {
                mask?.frame = CGRect(
                    x: 0, y: 0,
                    width: bounds.width * value,
                    height: bounds.height
                )
            }
        }
        
        /** Color */
        var color: UIColor = Color.blue.light
        
        /** image size */
        var size: CGFloat = 40
        
        /** container width */
        var width: CGFloat = UIScreen.main.bounds.width - 20 {
            didSet { view_bounds() }
        }
        
        /** is show or done */
        func update(type: Bool) {
            if type {
                backgroundColor = Color.gray.light
                name.textColor = Color.dark
                count.textColor = Color.dark
                progress.textColor = Color.gray.halftone
            } else {
                backgroundColor = color
                name.textColor = Color.white
                count.textColor = Color.white
                progress.textColor = Color.gray.thin
            }
        }
        
        // MARK: - Deploy
        
        override func view_deploy() {
            super.view_deploy()
            addSubview(image)
            addSubview(name)
            addSubview(count)
            addSubview(progress)
            
            layer.cornerRadius = 10
            mask = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
            mask?.backgroundColor = UIColor.black
            mask?.layer.cornerRadius = 10
        }
        
        // MARK: - Bounds
        
        override func view_bounds() {
            super.view_bounds()
            mask?.frame = CGRect(
                x: 0, y: 0,
                width: bounds.width * value,
                height: bounds.height
            )
            
            image.frame = CGRect(
                x: 10, y: (bounds.height - 40) / 2,
                width: size, height: size
            )
            
            count.sizeToFit()
            progress.sizeToFit()
            count.center = CGPoint(
                x: width - count.bounds.width / 2 - 10,
                y: bounds.height / 2 - 10
            )
            progress.center = CGPoint(
                x: count.center.x,
                y: bounds.height / 2 + 10
            )
            
            name.frame = CGRect(
                x: image.frame.maxX + 8, y: 8,
                width: count.frame.minX - image.frame.maxX - 16,
                height: bounds.height - 16
            )
        }
        
        // MARK: - Image
        
        let image: UIImageView = {
            let view = UIImageView()
            view.image = #imageLiteral(resourceName: "alarm-clock")
            return view
        }()
        
        let name: UILabel = {
            let label = UILabel()
            label.font = Font.text.b
            label.text = "习惯名称"
            return label
        }()
        
        let count: UILabel = {
            let label = UILabel()
            label.font = Font.text.s
            label.text = "10分钟"
            return label
        }()
        
        let progress: UILabel = {
            let label = UILabel()
            label.font = Font.text.s
            label.text = "0%"
            return label
        }()
        
    }
    
}

// MARK: - Actions

extension HabitListCell {
    
    class Actions: View {
        
        /** color */
        var color: UIColor = Color.blue.light
        
        // MARK: - Deploy
        
        override func view_deploy() {
            super.view_deploy()
            for button in buttons {
                button.normal_color = color
            }
        }
        
        // MARK: - Bounds
        
        override func view_bounds() {
            super.view_bounds()
        }
        
        // MARK: - Buttons
        
        let buttons: [Button] = {
            var buttons = [Button]()
            for image in [#imageLiteral(resourceName: "but_cut_w"), #imageLiteral(resourceName: "but_add_w"), #imageLiteral(resourceName: "but_sure_w")] {
                let button = Button(type: .system)
                button.setImage(image, for: .normal)
                button.corner = 10
                buttons.append(button)
            }
            return buttons
        }()
    }
    
}
