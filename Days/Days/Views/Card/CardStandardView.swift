//
//  CardStandardView.swift
//  Days
//
//  Created by Myron on 2018/5/25.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class CardStandardView: CardBaseView {
    
    // MARK: - Value
    
    /** Edge */
    var edge: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    /** Space title to container */
    var space: CGFloat = 20
    
    /** Title text */
    var title_text: String { return "" }
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        title.text = title_text
        
        addSubview(title)
        addSubview(container)
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        let w = bounds.width - edge.left - edge.right
        
        title.frame = CGRect(
            x: edge.left, y: edge.top,
            width: w, height: 40
        )
        
        container.frame = CGRect(
            x: edge.left, y: title.frame.maxY + space, width: w,
            height: bounds.height - title.frame.maxY - space - edge.bottom
        )
    }
    
    // MARK: - Title
    
    let title: UILabel = {
        let label = UILabel()
        label.font = Font.title.b
        label.text = "标题"
        label.textColor = Color.dark
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Back
    
    let container: View = {
        let view = View()
        view.corner = 10
        view.backgroundColor = Color.gray.light
        return view
    }()
    
}
