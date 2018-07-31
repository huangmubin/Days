//
//  App.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class App {
    
    
    
}

// MARK: - Frame

extension App {
    
    class Screen {
        static let width: CGFloat = UIScreen.main.bounds.width
        static let height: CGFloat = UIScreen.main.bounds.height
        static let y: CGFloat = UIApplication.shared.statusBarFrame.maxY
        static let content: CGFloat = UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.maxY
    }
    
    class Content {
        static let corner: CGFloat = {
            return UIDevice.iPhoneX() ? CGFloat(38.0) : CGFloat(20.0)
        }()
        class shadow {
            static let opacity: Float = 0.2
            static let offset: CGSize = CGSize.zero
        }
        
        static let top: CGRect = {
            if UIDevice.iPhone() {
                return CGRect(
                    x: 0,
                    y: UIApplication.shared.statusBarFrame.maxY,
                    width: UIScreen.main.bounds.width,
                    height: 60
                )
            } else {
                return CGRect(
                    x: 0,
                    y: UIApplication.shared.statusBarFrame.maxY,
                    width: UIScreen.main.bounds.width * 0.4,
                    height: 60
                )
            }
        }()
        
        static let sub: CGRect = {
            if UIDevice.iPhone() {
                return CGRect(
                    x: 0,
                    y: top.maxY,
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height - top.maxY - 40
                )
            } else {
                return CGRect(
                    x: 0,
                    y: top.maxY,
                    width: top.width,
                    height: UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.maxY
                )
            }
        }()
        
        static let content: CGRect = {
            if UIDevice.iPhone() {
                return CGRect(
                    x: 0,
                    y: top.maxY,
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height - top.maxY
                ).insetBy(dx: 2, dy: 2)
            } else {
                return CGRect(
                    x: top.maxX,
                    y: UIApplication.shared.statusBarFrame.maxY,
                    width: UIScreen.main.bounds.width * 0.5,
                    height: UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.maxY
                ).insetBy(dx: 2, dy: 2)
            }
        }()
        
        static let menu: CGRect = {
            if UIDevice.iPhone() {
                return CGRect(
                    x: 0,
                    y: top.maxY,
                    width: UIScreen.main.bounds.width,
                    height: 0
                )
            } else {
                return CGRect(
                    x: content.maxX,
                    y: UIApplication.shared.statusBarFrame.maxY,
                    width: UIScreen.main.bounds.width - top.width - content.width,
                    height: 0
                )
            }
        }()
    }
    
}

// MARK: - Status

extension App {
    static var is_portrait: Bool {
        return UIApplication.shared.statusBarOrientation.isPortrait
    }
}
