//
//  TeletextButton.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class TeletextButton: UIButton {
    
    let label = UILabel()
    var space: CGFloat = 4
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRect.zero)
        view_deploy()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view_deploy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view_deploy()
    }
    
    convenience init(image: UIImage?, text: String) {
        self.init(type: .custom)
        self.setImage(image, for: .normal)
        self.label.text = text
        view_deploy()
    }
    
    /** 初始化 */
    public func view_deploy() {
        addSubview(label)
        imageEdgeInsets.bottom = 20
        label.textAlignment = .center
    }
    
    // MARK: - Size
    
    override public var frame: CGRect {
        didSet{
            if frame.size != oldValue.size {
                view_bounds()
            }
        }
    }
    override public var bounds: CGRect {
        didSet {
            if bounds.size != oldValue.size {
                view_bounds()
            }
        }
    }
    
    /** 大小变化 */
    public func view_bounds() {
        let offset = (bounds.width - bounds.height + imageEdgeInsets.bottom) / 2
        imageEdgeInsets.left  = offset
        imageEdgeInsets.right = offset
        label.frame = CGRect(
            x: 0, y: bounds.height - imageEdgeInsets.bottom + space,
            width: bounds.width,
            height: 20
        )
    }
    
}
