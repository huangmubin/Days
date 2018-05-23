//
//  Resource.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class Resource {
    
    // MARK: - Init
    
    private init() {
        try? FileManager.default.createDirectory(
            atPath: "\(NSHomeDirectory())/Documents/Images/",
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    static let `default` = Resource()
    
    // MARK: - Image
    
    /** 根据名称跟颜色获取图片 */
    class func image(_ name: String, _ color: Int) -> UIImage {
        return Resource.default.image(name, color)
    }
    private func image(_ name: String, _ color: Int) -> UIImage {
        let path = "\(NSHomeDirectory())/Documents/Images/\(name)_\(color).png"
        if let image = UIImage(contentsOfFile: path) {
            return image
        } else {
            let image = UIImage(named: name)!
            let image_c = image.change(color: UIColor(color))!
            let data = UIImagePNGRepresentation(image_c)!
            try! data.write(to: URL(fileURLWithPath: path))
            return image_c
        }
    }
    
}
