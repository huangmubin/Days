//
//  Font.swift
//  Days3
//
//  Created by Myron on 2018/7/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class Font {
    
    static let normal: UIFont = Font.regular(20)
    static let small: UIFont  = Font.regular(12)
    
    // MARK: - Tools
    
    class func ultralight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Ultralight", size: size)!
    }
    class func thin(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Thin", size: size)!
    }
    class func light(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Light", size: size)!
    }
    class func regular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size)!
    }
    class func medium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size)!
    }
    class func semibold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size)!
    }
}
