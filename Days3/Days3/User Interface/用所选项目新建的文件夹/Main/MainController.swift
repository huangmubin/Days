//
//  MainController.swift
//  Days3
//
//  Created by Myron on 2018/7/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MainController: RootController {

    var date: Date = Date()
    
    func update(date: Date, view: View) {
        self.date = date
        if view !== top {
            top.date = date
            top.reload()
        }
        if view !== days {
            days.date = date
            days.reload()
        }
        if content !== days {
            content.reload()
        }
    }
    
    // MARK: - Load
    
    override func loadView() {
        super.loadView()
        view.addSubview(top)
        top.controller = self
        
        view.addSubview(menu)
        menu.controller = self
        
        view.addSubview(days)
        days.controller = self
        days.reload()
        
        view.addSubview(content)
        content.controller = self
        content.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deploy_present()
        view_bounds()
    }
    
    func view_bounds() {
        top.frame     = App.Content.top
        days.frame    = App.Content.tint
        content.frame = App.Content.content
        menu.frame    = App.Content.menu
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present_view.animation(show: false)
    }
    
    // MARK: - Views
    
    let top: MainTop = MainTop()
    
    let days: MainDays = MainDays()

    let menu: MainMenu = MainMenu()
    
    let content: MainContent = MainContent()
    
    // MARK: - Actions
    
    func view_days(show: Bool) {
        guard App.is_portrait else {
            return
        }
        guard menu.isHidden else {
            return
        }
        
        if show { days.isHidden = false }
        
        let top_y = show ? -top.frame.height : App.Screen.y
        let day_y = show ? App.Screen.y : top.frame.height + App.Screen.y
        let con_y = show ? days.frame.maxY : top.frame.height + App.Screen.y
        
        UIView.animate(withDuration: 0.5, animations: {
            self.top.frame.origin.y = top_y
            self.days.frame.origin.y = day_y
            self.content.frame.origin.y = con_y
            
            self.content.table.alpha = show ? 0 : 1
        }, completion: { _ in
            if !show { self.days.isHidden = true }
        })
        
        if show {
            UIView.animate(withDuration: 0.2, animations: {
                self.top.left.alpha = 0
                self.top.right.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveLinear, animations: {
                self.top.left.alpha = 1
                self.top.right.alpha = 1
            }, completion: nil)
        }
    }
    
    func view_menu(show: Bool) {
        guard App.is_portrait else {
            return
        }
        if show { self.menu.isHidden = false }
        UIView.animate(withDuration: 0.5, animations: {
            self.content.frame.origin.y = show ? self.menu.frame.maxY : self.top.frame.maxY
        }, completion: { _ in
            if !show { self.menu.isHidden = true }
        })
    }
    
    func view_push(index: Int, sender: Any) {
        func label_button() -> (LabelButton, UIImage, CGRect) {
            let button = sender as! LabelButton
            let frame = button.imageView!.frame
                .offsetBy(dx: button.frame.minX, dy: button.frame.minY)
                .offsetBy(dx: menu.scroll.contentOffset.x, dy: menu.scroll.contentOffset.y)
                .offsetBy(dx: menu.scroll.frame.minX, dy: menu.scroll.frame.minY)
                .offsetBy(dx: menu.frame.minX, dy: menu.frame.minY)
            return (
                button,
                UIImage(named: "ui_main_push_\(button.tag)")!,
                frame
            )
        }
        
        switch index {
        case 0:
            let values = label_button()
            values.0.isHidden = true
            present_view.update(image: values.1, frame: values.2)
            present_view.update(hidden: false)
            present_view.animation(show: true, complete: {
                values.0.isHidden = false
                let project = ProjectController()
                self.present_view.to_next(present: project.present_view)
                self.present(project, animated: false, completion: {
                    self.present_view.update(image: nil, frame: CGRect.zero, alpha: 1)
                })
            })
        default:
            print("Main Controller view push index = \(index) is a invalid value.")
        }
    }
    
    // MARK: - Animate
    
    let present_view = PresentAnimation()
    
    private func deploy_present() {
        view.addSubview(present_view)
        present_view.frame = view.bounds
    }
    
}
