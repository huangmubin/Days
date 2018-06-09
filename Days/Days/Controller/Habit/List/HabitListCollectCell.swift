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
        
        var habit: Habit { return (controller as? HabitListController)!.objs[index.row] }
        var is_menu: Bool { return show.frame.width > progress.frame.width }
        
        // MARK: - Reload
        
        override func view_reload() {
            super.view_reload()
            let obj = habit
            let length = obj.units(date: obj.date.date).count(value: { $0.obj.length })
            let unit_progress = length * 100 / obj.obj.frequency
            
            // color
            progress.color = obj.color
            progress.update(type: false)
            menu.color = obj.color
            
            // Length
            if length == 0 {
                menu.decrease.isUserInteractionEnabled = false
                menu.decrease.backgroundColor = obj.color.withAlphaComponent(0.5)
            } else {
                menu.decrease.isUserInteractionEnabled = true
            }
            if length >= obj.obj.frequency {
                menu.complete.isUserInteractionEnabled = false
                menu.complete.backgroundColor = obj.color.withAlphaComponent(0.5)
            } else {
                menu.complete.isUserInteractionEnabled = true
            }
            
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
            
            progress.frame = CGRect(
                x: show.frame.minX, y: show.frame.minY,
                width: show.mask!.bounds.width,
                height: show.bounds.height
            )
            
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
                width: menu.bounds.width - menu.frame.minX,
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
            Impact.light()
            menu.animation(menu.decrease)
            habit.units(remove: habit.date.date)
            UIView.animate(withDuration: 0.25, animations: {
                self.view_reload()
            })
        }
        @objc func increase_action() {
            Impact.heavy()
            menu.animation(menu.increase)
            let unit = HabitUnit(habit)
            unit.obj.id = SQLite.HabitUnit.new_id
            unit.obj.insert()
            habit.units(insert: habit.date.date, unit: unit)
            UIView.animate(withDuration: 0.25, animations: {
                self.view_reload()
            })
        }
        @objc func complete_action() {
            Impact.heavy()
            menu.animation(menu.complete)
            let units = habit.units(date: habit.date.date)
            let length = units.count(value: { $0.obj.length })
            if length < habit.obj.frequency {
                let unit = HabitUnit(habit)
                unit.obj.id = SQLite.HabitUnit.new_id
                unit.obj.length = habit.obj.frequency - length
                unit.obj.insert()
                habit.units(insert: habit.date.date, unit: unit)
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.view_reload()
            })
        }
        
        // MARK: - Gesture
        
        var pan: UIPanGestureRecognizer!
        var pan_start: CGFloat = 0
        var pan_status: Bool = true
        @objc func pan_action(_ sender: UIPanGestureRecognizer) {
            switch sender.state {
            case .began:
                pan_start = 10 + show.mask!.bounds.width
                pan_status = progress.bounds.width < (bounds.width / 2)
            case .ended:
                var complete: Bool = false
                if menu.is_auto_complete || sender.velocity(in: self).x < -4000 {
                    complete = true
                    complete_action()
                }
                
                let location = (sender.translation(in: self).x + pan_start) < (self.bounds.width / 2)
                switch (complete, pan_status, location, sender.velocity(in: self).x) {
                case (false, true, true, -2000 ..< 2000), (false, false, true, _), (false, false, false, -100000 ..< -2000):
                    UIView.animate(withDuration: 0.25, animations: {
                        self.show.value = (self.show.size + 20) / self.show.frame.width
                        self.progress.frame.size.width = self.show.mask!.bounds.width
                        self.menu.frame.origin.x = self.progress.frame.maxX + 10
                        self.menu.mask?.frame = CGRect(x: 0, y: 0, width: self.show.frame.maxX - self.menu.frame.minX, height: self.menu.frame.height)
                        self.shadow_view.frame = self.progress.frame
                    })
                default:
                    UIView.animate(withDuration: 0.25, animations: {
                        self.show.value = 1
                        self.progress.frame.size.width = self.show.mask!.bounds.width
                        self.menu.frame.origin.x = self.bounds.width
                        self.menu.mask?.frame = CGRect(x: 0, y: 0, width: -10, height: self.menu.frame.height)
                        self.shadow_view.frame = self.progress.frame
                    })
                }
            default:
                let x = sender.translation(in: self).x + pan_start - show.frame.minX
                show.value = x / show.frame.width
                progress.frame.size.width = show.mask!.bounds.width
                menu.frame.origin.x = progress.frame.maxX + 10
                
                menu.mask?.frame = CGRect(x: 0, y: 0, width: show.frame.maxX - menu.frame.minX, height: menu.frame.height)
                
                shadow_view.frame = progress.frame
                
                menu.auto_compelete(open: x <= show.image.frame.maxX)
                menu.frame.size.width = max(_menu_frame_width, bounds.width - 10 - menu.frame.origin.x)
            }
        }
        
        override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
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
                for button in [decrease, increase, complete] {
                    button.backgroundColor = color
                }
            }
        }
        
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
            UIView.animate(withDuration: 0.125, animations: {
                button.frame = new
            }, completion: { _ in
                UIView.animate(withDuration: 0.125, animations: {
                    button.frame = old
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
