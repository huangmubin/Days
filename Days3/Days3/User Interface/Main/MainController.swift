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
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let top_y = UIApplication.shared.statusBarFrame.maxY
        if App.is_portrait {
            top.frame = CGRect(
                x: 0, y: top_y,
                width: width, height: App.top_view_height
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
                height: min(menu.update(column: 2), height * 0.5)
            )
            
            days.isHidden = true
            menu.isHidden = true
        } else {
            top.frame = CGRect(
                x: 0, y: -App.top_view_height,
                width: width * 0.3, height: App.top_view_height
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
            
            menu.update(column: 1)
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
        guard App.is_portrait else {
            return
        }
        guard menu.isHidden else {
            return
        }
        
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
            push_card(
                image: values.1,
                origin: values.2,
                complete: {
//                    let project = ProjectController()
//                    self.present(project, animated: false, completion: nil)
            })
        default:
            print("Main Controller view push index = \(index) is a invalid value.")
        }
    }
    
    // MARK: - Animate
    
    private let present_black: UIView = UIView()
    private let present_card: UIView = UIView()
    private let present_image: UIImageView = UIImageView()
    
    private func deploy_present() {
        view.addSubview(present_black)
        view.addSubview(present_card)
        view.addSubview(present_image)
        present_black.backgroundColor = Color.white
        present_card.backgroundColor  = Color.white
        present_card.layer.shadowOffset = CGSize.zero
        present_card.layer.shadowOpacity = App.shadow_opacity
    }
    
    private func push_card(image: UIImage?, origin: CGRect, complete: @escaping () -> Void) {
        present_image.image = image
        present_image.frame = origin
        present_image.isHidden = false
        
        present_card.frame  = origin.insetBy(dx: origin.width / 2, dy: origin.height / 2)
        present_card.layer.borderColor = Color.black.cgColor
        present_card.layer.borderWidth = 0.5
        present_card.layer.cornerRadius = min(origin.width, origin.height) / 2
        present_card.isHidden = false
        
        present_black.frame = view.bounds
        present_black.alpha = 0
        present_card.isHidden = false
        
        let width = App.is_portrait ? view.bounds.width : view.bounds.width * 0.5
        let card_frame = CGRect(
            x: (view.bounds.width - width) / 2,
            y: App.top_view_height + App.top_y,
            width: width,
            height: App.height_untop - App.top_view_height
        ).insetBy(dx: 4, dy: 4)
        let image_frame = CGRect(
            x: card_frame.midX - width * 0.2,
            y: card_frame.midY - width * 0.2,
            width: width * 0.4, height: width * 0.4
        )
        
        self.present_card.layer.cornerRadius = UIDevice.iPhoneX() ? App.corner_x : App.corner
        self.present_card.layer.borderWidth = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.present_card.frame  = card_frame
            self.present_image.frame = image_frame
            self.present_black.alpha = 1
        }, completion: { _ in complete() })
    }
    
}
