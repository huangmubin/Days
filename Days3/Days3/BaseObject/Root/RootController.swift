//
//  RootController.swift
//  Days3
//
//  Created by Myron on 2018/7/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class RootController: ViewController {

    // MARK: - Load
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.iPhone() {
            return .portrait
        } else {
            return .all
        }
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        view_load()
        view_deploy()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_bounds()
        
        sub.reload()
        content.reload()
    }
    
    func view_load() { }
    
    func view_deploy() {
        view.addSubview(sub)
        sub.frame = App.Content.sub
        sub.isHidden = App.is_portrait
        sub.controller = self
        
        view.addSubview(menu)
        menu.frame = App.Content.menu
        menu.isHidden = App.is_portrait
        menu.controller = self
        
        view.addSubview(top)
        top.frame = App.Content.top
        top.controller = self
        
        view.addSubview(content)
        content.frame = App.Content.content
        content.controller = self
        
        view.addSubview(present)
        present.frame = view.bounds
        present.controller = self
    }
    
    func view_bounds() {
        present.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present.animation(show: false)
    }
    
    // MARK: - View
    
    var top: RootTop!
    var sub: RootSub!
    var content: RootContent!
    var menu: RootMenu!
    var present = RootPresent()
    
    // MARK: - Action
    
    func update(date: Date, sender: Any) {
        
    }
    
    func view_sub(show: Bool) {
        guard App.is_portrait && menu.isHidden else {
            return
        }
        
        if show { sub.isHidden = false }
        
        let top_y = show ? -top.frame.height : App.Screen.y
        let day_y = show ? App.Screen.y : top.frame.height + App.Screen.y
        let con_y = show ? sub.frame.maxY : top.frame.height + App.Screen.y
        
        UIView.animate(withDuration: 0.5, animations: {
            self.top.frame.origin.y = top_y
            self.sub.frame.origin.y = day_y
            self.content.frame.origin.y = con_y
        }, completion: { _ in
            if !show { self.sub.isHidden = true }
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
        switch index {
        case 0:
            if let teletext = sender as? TeletextButton {
                teletext.isHidden = true
                present.update(
                    image: UIImage(named: "ui_main_push_\(teletext.tag)"),
                    frame: teletext.imageView!.frame(in: view)
                )
                present.isHidden = false
                present.animation(show: true, complete: {
                    teletext.isHidden = false
                    let project = ProjectController()
                    self.present.to(project.present)
                    self.present(project, animated: false, completion: {
                        self.present.update(image: nil, frame: CGRect.zero, alpha: 1)
                    })
                })
            }
        default:
            print("Main Controller view push index = \(index) is a invalid value.")
        }
    }
    
    func view_dismiss(sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.top.frame.origin.y = -self.top.frame.height
            self.content.frame.origin.y = App.Screen.height
            self.sub.frame.origin.x = -self.sub.frame.width
            self.menu.frame.origin.x = App.Screen.width
        }, completion: { _ in
            DispatchQueue.main.delay(time: 0.5, execute: {
                self.dismiss(animated: false, completion: nil)
            })
        })
    }
    
}
