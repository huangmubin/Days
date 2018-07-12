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
        
        view_bounds()
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
            title.titleLabel?.sizeToFit()
            subtitle.sizeToFit()
            let y = (bounds.height - title.frame.height - subtitle.frame.height) / 2
            let e = (title.frame.height - title.titleLabel!.frame.height) / 2
            title.frame = CGRect(
                x: left_button.frame.maxX,
                y: y,
                width: bounds.width - 20 - left_button.frame.width - right_button.frame.width,
                height: title.frame.height
            )
            subtitle.frame = CGRect(
                x: title.frame.minX,
                y: title.frame.maxY - e,
                width: title.frame.width,
                height: subtitle.frame.height
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
    
    var title: UIButton! = Views.Button.title(small: "")
    @objc func title_action(_ sender: UIButton) { }
    
    // MARK: - Subtitle
    
    var subtitle: UILabel! = Views.Label.hint("")

}
