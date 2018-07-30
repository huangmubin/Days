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

// MARK: - Size

extension App {
    static let corner: CGFloat = 20
    static let shadow_opacity: Float = 0.2
    static let corner_x: CGFloat = 38
    
    static var top_y: CGFloat {
        return UIApplication.shared.statusBarFrame.maxY
    }
    static let top_view_height: CGFloat = 60
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    static var height_untop: CGFloat {
        return UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.maxY
    }
}

// MARK: - Status

extension App {
    static var is_portrait: Bool {
        return UIApplication.shared.statusBarOrientation.isPortrait
    }
}
