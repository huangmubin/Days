//
//  RootPresent.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class RootPresent: View {
    
    weak var controller: RootController!
    
    // MARK: - Action
    
    func update(image _image: UIImage?, frame: CGRect, alpha: CGFloat = 0) {
        black.alpha = alpha
        black.frame = bounds
        
        card.frame  = frame.insetBy(dx: frame.width / 2, dy: frame.height / 2)
        card.layer.borderWidth = 0.5
        card.layer.cornerRadius = min(frame.width, frame.height) / 2
        
        image.image = _image
        image.frame = frame
    }
    
    func animation(show: Bool, complete: (() -> Void)? = nil) {
        if show {
            let card_frame = App.Content.content
            let image_width = card_frame.width * 0.4
            let image_frame = card_frame.insetBy(
                dx: (card_frame.width - image_width) / 2,
                dy: (card_frame.height - image_width) / 2
            )
            
            card.layer.borderWidth  = 0
            card.layer.cornerRadius = App.Content.corner
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.card.frame  = card_frame
                self.image.frame = image_frame
                self.black.alpha = 1
            }, completion: { _ in complete?() })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.isHidden = true
                self.alpha = 1
                complete?()
            })
        }
    }
    
    func to(_ present: RootPresent) {
        present.black.backgroundColor = black.backgroundColor
        present.black.alpha = black.alpha
        present.black.frame = black.frame
        
        present.card.backgroundColor    = card.backgroundColor
        present.card.layer.cornerRadius = card.layer.cornerRadius
        present.card.layer.borderWidth  = card.layer.borderWidth
        present.card.frame = card.frame
        
        present.image.image = image.image
        present.image.frame = image.frame
        
        present.isHidden = isHidden
    }
    
    // MARK: - Sub View
    
    let black: UIView      = UIView()
    let card: UIView       = UIView()
    let image: UIImageView = UIImageView()
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        isUserInteractionEnabled = false
        isHidden = true
        
        addSubview(black)
        black.backgroundColor = Color.white
        
        addSubview(card)
        card.backgroundColor = Color.white
        card.layer.borderColor = Color.black.cgColor
        card.layer.shadowOpacity = App.Content.shadow.opacity
        card.layer.shadowOffset = CGSize.zero
        
        addSubview(image)
    }
    
}
