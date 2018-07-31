//
//  PresentAnimation.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/31.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class PresentAnimation: View {

    // MARK: - Values
    
    // MARK: - Action
    
    func update(image: UIImage?, frame: CGRect, alpha: CGFloat = 0) {
        self.black.alpha = alpha
        self.black.frame = bounds
        
        self.card.frame  = frame.insetBy(dx: frame.width / 2, dy: frame.height / 2)
        self.card.layer.borderWidth = 0.5
        self.card.layer.cornerRadius = min(frame.width, frame.height) / 2
        
        self.image.image = image
        self.image.frame = frame
    }
    
    func update(hidden: Bool) {
        self.isHidden = hidden
    }
    
    func animation(show: Bool, to_frame: CGRect? = nil, complete: (() -> Void)? = nil) {
        if show {
            let card_frame = App.Content.content
            let image_width = card_frame.width * 0.4
            let image_frame = card_frame.insetBy(
                dx: (card_frame.width - image_width) / 2,
                dy: (card_frame.height - image_width) / 2
            )
//            let width = App.is_portrait ? superview!.bounds.width : superview!.bounds.width * 0.5
//            let card_frame = to_frame ?? CGRect(
//                x: (superview!.bounds.width - width) / 2,
//                y: App.top_view_height + App.top_y,
//                width: width,
//                height: App.height_untop - App.top_view_height
//                ).insetBy(dx: 4, dy: 4)
//            let image_frame = CGRect(
//                x: card_frame.midX - card_frame.width * 0.2,
//                y: card_frame.midY - card_frame.width * 0.2,
//                width: card_frame.width * 0.4, height: card_frame.width * 0.4
//            )
            
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
                self.update(hidden: true)
                self.alpha = 1
                complete?()
            })
        }
    }
    
    func to_next(present: PresentAnimation) {
        present.black.backgroundColor = black.backgroundColor
        present.black.alpha = black.alpha
        present.black.frame = black.frame
        
        present.card.backgroundColor = card.backgroundColor
        present.card.layer.cornerRadius = card.layer.cornerRadius
        present.card.layer.borderWidth  = card.layer.borderWidth
        present.card.frame = card.frame
        
        present.image.image = image.image
        present.image.frame = image.frame
        
        present.isHidden = isHidden
    }
    
    // MARK: - Sub View
    
    let black: UIView = UIView()
    let card: UIView = UIView()
    let image: UIImageView = UIImageView()
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        isUserInteractionEnabled = false
        addSubview(black)
        addSubview(card)
        addSubview(image)
        update(hidden: true)
        
        black.backgroundColor = Color.white
        
        card.backgroundColor = Color.white
        card.layer.borderColor = Color.black.cgColor
        card.layer.shadowOpacity = App.Content.shadow.opacity
        card.layer.shadowOffset = CGSize.zero
    }
    
    
}
