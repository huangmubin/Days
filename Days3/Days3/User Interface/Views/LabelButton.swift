//
//  LabelButton.swift
//  Days3
//
//  Created by Myron on 2018/7/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class LabelButton: UIButton {

    let label = UILabel()
    
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
        let space = (bounds.width - bounds.height + 20) / 2
        imageEdgeInsets.left  = space
        imageEdgeInsets.right = space
        label.center = CGPoint(x: bounds.width / 2, y: bounds.height - 10)
    }

}
