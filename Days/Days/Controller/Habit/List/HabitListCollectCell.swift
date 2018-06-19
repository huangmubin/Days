//
//  HabitListCollectCell.swift
//  Days
//
//  Created by Myron on 2018/6/8.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

extension HabitListCollect {
    
    class Cell: CollectionViewCell, UIGestureRecognizerDelegate {
        
        var habit: Habit!
        var is_menu: Bool { return show.frame.width > progress.frame.width }
        
        // MARK: - Reload
        
        override func view_reload() {
            super.view_reload()
            let obj = habit ?? Habit()
            let length = obj.units(date: obj.date.date).count(value: { $0.obj.length })
            let unit_progress = length * 100 / obj.obj.frequency
            
            // color
            progress.color = obj.color
            progress.update(type: false)
            
            menu.can_decrease = (length != 0)
            menu.can_complete = (length < obj.obj.frequency)
            menu.color = obj.color
            
            // Image
            show.image.image = obj.image()
            progress.image.image = obj.image(color: Color.white)
            progress.value = CGFloat(unit_progress) / 100
            
            // text
            for view in [show, progress] {
                view.name.text = obj.obj.name
                if obj.obj.is_time {
                    view.count.text = Format.time_text(second: length)
                } else {
                    view.count.text = "\(length)次"
                }
                view.progress.text = "\(unit_progress)%"
            }
            
            // update
            view_bounds()
        }
        
        // MARK: - View Deploy
        
        override func view_load() {
            super.view_load()
            clipsToBounds = true
            
            addSubview(show)
            addSubview(progress)
            addSubview(menu)
            
            menu.decrease.addTarget(self, action: #selector(decrease_action), for: .touchUpInside)
            menu.increase.addTarget(self, action: #selector(increase_action), for: .touchUpInside)
            menu.complete.addTarget(self, action: #selector(complete_action), for: .touchUpInside)
            
            progress.mask?.layer.cornerRadius = 0
            menu.mask = UIView()
            menu.mask?.backgroundColor = Color.white
            menu.mask?.layer.cornerRadius = show.layer.cornerRadius
            menu.auto_compelete(open: false)
            
            pan = UIPanGestureRecognizer(target: self, action: #selector(pan_action(_:)))
            pan.delegate = self
            addGestureRecognizer(pan)
            
            long = UILongPressGestureRecognizer(target: self, action: #selector(long_action(_:)))
            long.delegate = self
            addGestureRecognizer(long)
            
            insertSubview(shadow_view, at: 0)
            shadow_view.layer.cornerRadius = 10
            shadow_view.layer.shadowOffset.height = 3
        }
        
        // MARK: - View Bounds
        
        private var _menu_frame_width: CGFloat = 0
        override func view_bounds() {
            super.view_bounds()
            show.frame = CGRect(
                x: 10, y: 10,
                width: bounds.width - 20,
                height: bounds.height - 20
            )
            show.width = bounds.width - 20
            
            progress.frame = CGRect(
                x: show.frame.minX, y: show.frame.minY,
                width: show.mask!.bounds.width,
                height: show.bounds.height
            )
            progress.width = bounds.width - 20
            
            _menu_frame_width = show.bounds.width - show.size - 30
            menu.frame = CGRect(
                x: progress.frame.maxX + 10,
                y: show.frame.minY,
                width: _menu_frame_width,
                height: show.bounds.height
            )
            menu.mask?.frame = CGRect(
                x: 0,
                y: 0,
                width: max(_menu_frame_width, bounds.width - 10 - menu.frame.origin.x),
                height: menu.frame.height
            )
            
            shadow_view.frame = show.frame
            if UIScreen.main.is_landscape {
                shadow_view.layer.shadowOpacity = 0.4
            } else {
                shadow_view.layer.shadowOpacity = 0
            }
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
        
        let menu: Actions = {
            let view = Actions()
            return view
        }()
        
        // MARK: - Actions
        
        @objc func decrease_action() {
            if menu.can_decrease {
                Impact.light()
                menu.animation(menu.decrease)
                habit.units(remove: habit.date.date)
                UIView.animate(withDuration: 0.25, animations: {
                    self.view_reload()
                })
            }
        }
        @objc func increase_action() {
            Impact.heavy()
            menu.animation(menu.increase)
            let unit = HabitUnit(habit)
            unit.obj.id = SQLite.HabitUnit.new_id
            unit.obj.start = habit.date.first(.day).advance(Double(Date().time))
            unit.obj.insert()
            habit.units(insert: habit.date.date, unit: unit)
            UIView.animate(withDuration: 0.25, animations: {
                self.view_reload()
            })
        }
        @objc func complete_action() {
            if menu.can_complete {
                Impact.heavy()
                menu.animation(menu.complete)
                let units = habit.units(date: habit.date.date)
                let length = units.count(value: { $0.obj.length })
                if length < habit.obj.frequency {
                    let unit = HabitUnit(habit)
                    unit.obj.id = SQLite.HabitUnit.new_id
                    unit.obj.start = habit.date.first(.day).advance(Double(habit.date.time))
                    unit.obj.length = habit.obj.frequency - length
                    unit.obj.insert()
                    habit.units(insert: habit.date.date, unit: unit)
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.view_reload()
                })
            }
        }
        
        // MARK: - Pan Gesture
        
        var pan: UIPanGestureRecognizer!
        var pan_start: CGFloat = 0
        var pan_status: Bool = true
        @objc func pan_action(_ sender: UIPanGestureRecognizer) {
            switch sender.state {
            case .began: // pan began
                pan_start = 10 + show.mask!.bounds.width
                pan_status = progress.bounds.width < (bounds.width / 2)
            case .ended: // pan ended
                var complete: Bool = false
                if menu.is_auto_complete || (sender.velocity(in: self).x < -4000 && progress.value < 1) {
                    complete = true
                    complete_action()
                }
                
                let location = (sender.translation(in: self).x + pan_start) < (self.bounds.width / 2)
                switch (complete, pan_status, location, sender.velocity(in: self).x) {
                case (false, true, true, -2000 ..< 2000), (false, false, true, _), (false, false, false, -100000 ..< -2000):
                    // open menu
                    UIView.animate(withDuration: 0.25, animations: {
                        self.show.value = (self.show.size + 20) / self.show.frame.width
                        self.progress.frame.size.width = self.show.mask!.bounds.width
                        self.menu.frame.origin.x = self.progress.frame.maxX + 10
                        self.menu.frame.size.width = self._menu_frame_width
                        self.menu.mask?.frame = CGRect(x: 0, y: 0, width: self.show.frame.maxX - self.menu.frame.minX, height: self.menu.frame.height)
                        self.shadow_view.frame = self.progress.frame
                    })
                default:
                    // close menu
                    let menu_mask_frame = CGRect(
                        x: -menu.mask!.frame.width - 10,
                        y: 0,
                        width: menu.mask!.frame.width,
                        height: menu.mask!.frame.height
                    )
                    UIView.animate(withDuration: 0.25, animations: {
                        self.show.value = 1
                        self.progress.frame.size.width = self.show.mask!.bounds.width
                        self.menu.frame.origin.x = self.bounds.width
                        self.menu.mask?.frame = menu_mask_frame
                        self.shadow_view.frame = self.progress.frame
                    })
                }
            default: // pan move
                let x = sender.translation(in: self).x + pan_start - show.frame.minX
                show.value = x / show.frame.width
                progress.frame.size.width = min(show.mask!.bounds.width, show.frame.width)
                menu.frame.origin.x = progress.frame.maxX + 10
                
                menu.mask?.frame = CGRect(x: 0, y: 0, width: show.frame.maxX - menu.frame.minX, height: menu.frame.height)
                
                shadow_view.frame = progress.frame
                
                if progress.value < 1 {
                    menu.auto_compelete(open: x <= show.image.frame.maxX)
                }
                menu.frame.size.width = max(_menu_frame_width, bounds.width - 10 - menu.frame.origin.x)
            }
        }
        
        // MARK: - Long Touch
        
        var long: UILongPressGestureRecognizer!
        @objc func long_action(_ sender: UILongPressGestureRecognizer) {
            if sender.state == .began {
                controller?.performSegue(
                    withIdentifier: "EditHabit",
                    sender: habit
                )
            }
        }
        
        // MARK: - Touch
        
        override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer === long {
                return true
            }
            if gestureRecognizer === pan {
                let offset = pan.velocity(in: self)
                return abs(offset.x) > abs(offset.y)
            }
            return false
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            if !is_menu {
                Impact.medium()
                let old_rect = show.frame
                let new_rect = CGRect(
                    x: old_rect.minX - 4, y: old_rect.minY - 4,
                    width: old_rect.width + 8, height: old_rect.height + 8
                )
                UIView.animate(withDuration: 0.25, animations: {
                    self.show.frame = new_rect
                    self.progress.frame = new_rect
                }, completion: { _ in
                    UIView.animate(withDuration: 0.25, animations: {
                        self.show.frame = old_rect
                        self.progress.frame = old_rect
                    })
                })
            }
        }
        
        // MARK: - Shadow View
        
        let shadow_view: UIView = {
            let view = UIView()
            view.backgroundColor = Color.white
            return view
        }()
        
    }
}


// MARK: - Container

extension HabitListCollect.Cell {
    
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
                progress.textColor = Color.gray.light
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
                x: image.frame.maxX + 10, y: 8,
                width: count.frame.minX - image.frame.maxX - 20,
                height: bounds.height - 16
            )
        }
        
        // MARK: - Image
        
        let image: UIImageView = UIImageView(image: #imageLiteral(resourceName: "alarm-clock"))
        
        let name: UILabel = Views.Label.normal("习惯名称", alignment: .left)
        let count: UILabel = Views.Label.hint("10分钟")
        let progress: UILabel = Views.Label.hint("0%")
        
    }
}

// MARK: - Actions

extension HabitListCollect.Cell {
    
    class Actions: View {
        
        /** color */
        var color: UIColor = Color.blue.light {
            didSet {
                decrease.backgroundColor = can_decrease ? color : color.withAlphaComponent(0.5)
                increase.backgroundColor = color
                complete.backgroundColor = can_complete ? color : color.withAlphaComponent(0.5)
            }
        }
        
        /***/
        var can_complete: Bool = true
        var can_decrease: Bool = true
        
        // MARK: - Deploy
        
        override func view_deploy() {
            super.view_deploy()
            for button in [decrease, increase, complete] {
                button.backgroundColor = color
                button.layer.cornerRadius = 10
                addSubview(button)
            }
        }
        
        // MARK: - Bounds
        
        override func view_bounds() {
            super.view_bounds()
            let w = (bounds.width - 20) / 3
            decrease.frame = CGRect(
                x: 0, y: 0,
                width: w, height: bounds.height
            )
            increase.frame = CGRect(
                x: decrease.frame.maxX + 10, y: 0,
                width: w, height: bounds.height
            )
            if is_auto_complete {
                complete.frame = CGRect(
                    x: 0, y: 0,
                    width: bounds.width, height: bounds.height
                )
            } else {
                complete.frame = CGRect(
                    x: increase.frame.maxX + 10, y: 0,
                    width: w, height: bounds.height
                )
            }
        }
        
        // MARK: - Buttons
        
        let decrease: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_cut_w"), tint: Color.white)
        let increase: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_add_w"), tint: Color.white)
        let complete: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_sure_w"), tint: Color.white)
        
        // MARK: - Animation
        
        func animation(_ button: UIButton) {
            let old = button.frame
            let new = CGRect(
                x: old.minX - 4, y: old.minY - 4,
                width: old.width + 8, height: old.height + 8
            )
            let old_mask = mask!.frame
            let new_mask = CGRect(
                x: old_mask.minX - 4, y: old_mask.minY - 4,
                width: old_mask.width + 8, height: old_mask.height + 8
            )
            UIView.animate(withDuration: 0.125, animations: {
                button.frame = new
                self.mask?.frame = new_mask
            }, completion: { _ in
                UIView.animate(withDuration: 0.125, animations: {
                    button.frame = old
                    self.mask?.frame = old_mask
                })
            })
        }
        
        
        var is_auto_complete: Bool = false
        func auto_compelete(open: Bool) {
            if is_auto_complete != open {
                is_auto_complete = open
                let rect = open ? CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height) : CGRect(x: increase.frame.maxX + 10, y: 0, width: increase.frame.width, height: bounds.height)
                UIView.animate(withDuration: 0.25, animations: {
                    self.complete.frame = rect
                })
            }
        }
        
    }
    
}
