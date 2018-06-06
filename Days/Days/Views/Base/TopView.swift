//
//  Top.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

/** Top Base View */
class TopView: View {

    weak var vc: ViewController?
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(left_button)
        addSubview(right_button)
        addSubview(title)
        addSubview(subtitle)
        
        left_button.addTarget(self, action: #selector(left_action(_:)), for: .touchUpInside)
        right_button.addTarget(self, action: #selector(right_action(_:)), for: .touchUpInside)
        title.addTarget(self, action: #selector(title_action(_:)), for: .touchUpInside)
    }
    
    override func view_bounds() {
        super.view_bounds()
        left_button.frame = CGRect(
            x: 10,
            y: (bounds.height - 60) / 2,
            width: 60, height: 60
        )
        right_button.frame = CGRect(
            x: bounds.width - 70,
            y: left_button.frame.minY,
            width: left_button.frame.width,
            height: left_button.frame.height
        )
        
        if subtitle.text?.isEmpty == false {
            subtitle.sizeToFit()
            title.frame = CGRect(
                x: left_button.frame.maxX,
                y: left_button.frame.minY - 10,
                width: bounds.width - 20 - left_button.frame.width - right_button.frame.width,
                height: left_button.frame.height
            )
            subtitle.center = CGPoint(
                x: title.center.x,
                y: title.center.y + 20
            )
        } else {
            title.frame = CGRect(
                x: left_button.frame.maxX,
                y: left_button.frame.minY,
                width: bounds.width - 20 - left_button.frame.width - right_button.frame.width,
                height: left_button.frame.height
            )
        }
    }
    
    // MARK: - Left
    
    var left_button: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_back"))
    @objc func left_action(_ sender: UIButton) {
        self.controller()?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Right
    
    var right_button: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_add"))
    @objc func right_action(_ sender: UIButton) { }
    
    // MARK: - Title
    
    var title: UIButton! = Views.Button.title()
    @objc func title_action(_ sender: UIButton) { }
    
    // MARK: - Subtitle
    
    var subtitle: UILabel! = Views.Label.hint("")

}
