//
//  HabitEditDefaultController.swift
//  Days
//
//  Created by Myron on 2018/6/9.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditDefaultController: BaseController {
    
    
    
}

extension HabitEditDefaultController {
    
    class Cell: CollectionViewCell {
        
        // MARK: - Views
        
        let image: UIImageView = UIImageView()
        let title: UILabel = Views.Label.title(small: "习惯名称", alignment: .left)
        
        // MARK: - Load
        
        override func view_load() {
            super.view_load()
            addSubview(image)
            addSubview(title)
        }
        
        
        override func view_reload() {
            super.view_reload()
            
        }
        
        override func view_bounds() {
            super.view_bounds()
            let image_size: CGFloat = 60
            image.frame = CGRect(
                x: 10, y: (bounds.height - image_size) / 2,
                width: image_size, height: image_size
            )
            title.sizeToFit()
            title.frame = CGRect(
                x: image.frame.maxX + 8, y: 0,
                width: bounds.width - image.frame.maxX,
                height: bounds.height
            )
        }
        
        
        
    }
    
}
