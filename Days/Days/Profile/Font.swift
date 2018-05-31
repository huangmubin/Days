//
//  Font.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

/** Font Profile */
class Font {
    
    /** 苹方-简 */
    class PingFangSC {
        /** 极细体 */
        static let ultralight: UIFont = UIFont(name: "PingFangSC-Ultralight", size: 30)!
        /** 纤细体 */
        static let thin: UIFont = UIFont(name: "PingFangSC-Thin", size: 30)!
        /** 细体 */
        static let light: UIFont = UIFont(name: "PingFangSC-Light", size: 30)!
        /** 常规体 */
        static let regular: UIFont = UIFont(name: "PingFangSC-Regular", size: 30)!
        /** 中黑体 */
        static let medium: UIFont = UIFont(name: "PingFangSC-Medium", size: 30)!
        /** 中粗体 */
        static let semibold: UIFont = UIFont(name: "PingFangSC-Semibold", size: 30)!
    }

    /** 标题 */
    class title {
        static let b: UIFont = UIFont(name: "PingFangSC-Semibold", size: 30)!
        static let m: UIFont = UIFont(name: "PingFangSC-Semibold", size: 26)!
        static let s: UIFont = UIFont(name: "PingFangSC-Semibold", size: 24)!
    }
    
    /** 文本 */
    class text {
        static let b: UIFont = UIFont(name: "PingFangSC-Regular", size: 20)!
        static let m: UIFont = UIFont(name: "PingFangSC-Regular", size: 18)!
        static let s: UIFont = UIFont(name: "PingFangSC-Regular", size: 16)!
    }
    
    /** 提示 */
    class hint {
        static let b: UIFont = UIFont(name: "PingFangSC-Light", size: 16)!
        static let m: UIFont = UIFont(name: "PingFangSC-Light", size: 14)!
        static let s: UIFont = UIFont(name: "PingFangSC-Thin", size: 12)!
    }
    
}
