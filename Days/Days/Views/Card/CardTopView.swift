//
//  CardTopView.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class CardTopView: CardBaseView {

    /** default init */
    convenience init(id: String, height: CGFloat?, suspend: Bool) {
        self.init(id: id, height: height ?? 80)
        self.is_suspend = suspend
        //self.backgroundColor = Color.white
    }
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        insertSubview(mask_background, at: 0)
        
        container.backgroundColor = Color.white
        
        addSubview(left)
        addSubview(right)
        addSubview(title)
        addSubview(subtitle)
        
        left.addTarget(self, action: #selector(left_action(_:)), for: .touchUpInside)
        right.addTarget(self, action: #selector(right_action(_:)), for: .touchUpInside)
    }

    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        mask_background.frame = CGRect(
            x: edge.left, y: 0,
            width: bounds.width - edge.left - edge.right,
            height: bounds.height
        )
        
        //print("update the top view bount = \(frame)")
        left.frame = CGRect(
            x: 10, y: (bounds.height - 60) / 2,
            width: 60, height: 60
        )
        right.frame = CGRect(
            x: bounds.width - 70, y: left.frame.minY,
            width: 60, height: 60
        )
        
        title.sizeToFit()
        subtitle.sizeToFit()
        let y = (bounds.height - title.frame.height - subtitle.frame.height) / 2
        title.frame = CGRect(
            x: left.frame.maxX + 8, y: y,
            width: bounds.width - 156, // 10 60 8 - 8 60 10
            height: title.frame.height
        )
        subtitle.frame = CGRect(
            x: title.frame.minX,
            y: title.frame.maxY,
            width: title.frame.width,
            height: subtitle.frame.height
        )
    }

    // MARK: - Buttons
    
    let left: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "ui_bar_right"))
    let right: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "ui_bar_sure"))
    
    @objc func left_action(_ sender: UIButton) {
        //print("Left")
        table.controller?.dismiss(animated: true, completion: nil)
    }
    @objc func right_action(_ sender: UIButton) {
        //print("Right")
    }
    
    // MARK: - Labels
    //Views.Button.title()
    let title: UILabel = Views.Label.title(small: "标题")
    let subtitle: UILabel = Views.Label.hint("")
    
    // MARK: - Suspend
    
    /** 是否要进行悬浮 */
    var is_suspend: Bool = false
    
    override func reload() {
        super.reload()
        if is_suspend {
            table.bringSubview(toFront: self)
        }
    }
    
    override func scroll_action() {
        super.scroll_action()
        if is_suspend {
            frame.origin.y = table.contentOffset.y
        }
    }
    
    // MARK: - Mask Back ground
    
    /**  */
    var mask_background: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = Color.white
        return view
    }()
    
}
