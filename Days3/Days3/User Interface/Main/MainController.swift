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
        view_bounds()
    }
    
    func view_bounds() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let top_y = UIApplication.shared.statusBarFrame.maxY
        if UIApplication.shared.statusBarOrientation.isPortrait {
            top.frame = CGRect(
                x: 0, y: top_y,
                width: width, height: 60
            )
            
            days.frame = CGRect(
                x: 0, y: top.frame.maxY,
                width: top.frame.width,
                height: height - top.frame.maxY
            )
            
            content.frame = CGRect(
                x: 0, y: top.frame.maxY,
                width: width,
                height: height - top.frame.maxY
            )
            
            menu.frame = CGRect(
                x: 0, y: top.frame.maxY,
                width: width,
                height: menu.update(column: 2)
            )
            
            days.isHidden = true
            menu.isHidden = true
        } else {
            top.frame = CGRect(
                x: 0, y: -60,
                width: width * 0.3, height: 60
            )
            
            days.frame = CGRect(
                x: 0, y: top_y,
                width: top.frame.width,
                height: height - top_y
            )
            
            content.frame = CGRect(
                x: days.frame.maxX, y: top_y,
                width: width * 0.6,
                height: height - top_y - 10
            )
            
            menu.frame = CGRect(
                x: content.frame.maxX, y: top_y,
                width: width - content.frame.maxX,
                height: height - top_y
            )
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Views
    
    let top: MainTop = MainTop()
    
    let days: MainDays = MainDays()

    let menu: MainMenu = MainMenu()
    
    let content: MainContent = MainContent()
    
    // MARK: - Actions
    
    func view_days(show: Bool) {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            if show { days.isHidden = false }
            
            let status_y = UIApplication.shared.statusBarFrame.maxY
            let top_y = show ? -top.frame.height : status_y
            let day_y = show ? status_y : top.frame.height + status_y
            let con_y = show ? UIScreen.main.bounds.height - 40 : top.frame.height + status_y
            
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
    }
    
    func view_menu(show: Bool) {
        guard UIApplication.shared.statusBarOrientation.isPortrait else {
            return
        }
        if show { self.menu.isHidden = false }
        UIView.animate(withDuration: 0.5, animations: {
            self.content.frame.origin.y = show ? self.menu.frame.height : self.top.frame.maxY
        }, completion: { _ in
            if !show { self.menu.isHidden = true }
        })
    }
    
}
