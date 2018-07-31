//
//  ProjectController.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class ProjectController: RootController {
    
    // MARK: - Load
    
    override func loadView() {
        super.loadView()
        view.addSubview(top)
        top.controller = self
        top.image.image = present_view.image.image
        
        view.addSubview(content)
        content.backgroundColor = Color.white
        content.layer.shadowOffset = CGSize.zero
        content.layer.shadowOpacity = App.shadow_opacity
        content.layer.cornerRadius = App.corner
        print("is x = \(UIDevice.iPhoneX()) \(content.layer.cornerRadius)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deploy_present()
        view_bounds()
    }
    
    func view_bounds() {
        let width = UIScreen.main.bounds.width
        //let height = UIScreen.main.bounds.height
        let top_y = UIApplication.shared.statusBarFrame.maxY
        if App.is_portrait {
            top.frame = CGRect(
                x: 0, y: top_y,
                width: width, height: App.top_view_height
            )
            
        } else {
            top.frame = CGRect(
                x: width * 0.25, y: top_y,
                width: width * 0.5, height: App.top_view_height
            )
        }
        
        content.frame = CGRect(
            x: top.frame.minX + 2,
            y: top.frame.maxY + 2,
            width: top.frame.width - 4,
            height: view.bounds.height - top.frame.maxY - 4
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present_view.animation(show: false)
    }
    
    // MARK: - View
    
    let top: ProjectTop = ProjectTop()
    let content: ProjectContent = ProjectContent()
    
    // MARK: - Action
    
    func view_dismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.top.frame.origin.y = -self.top.frame.height
            self.content.frame.origin.y = self.view.bounds.height
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - Present
    
    let present_view = PresentAnimation()
    
    private func deploy_present() {
        view.addSubview(present_view)
        present_view.frame = view.bounds
    }
    
}
