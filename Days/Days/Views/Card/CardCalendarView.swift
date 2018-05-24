//
//  CardCalendarView.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol CardCalendarViewDelegate: class {
    func cardCalendar(view: CardCalendarView, update date: Date)
}

class CardCalendarView: CardBaseView, KeyboardDelegate {
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        
    }
    
    // MARK: - Values
    
    /**  */
    weak var delegate: CardCalendarViewDelegate?
    
    /** 当前代表日期 */
    var date: Date = Date() {
        didSet {
            delegate?.cardCalendar(view: self, update: date)
            date_button.setTitle(Format.yyyy_年_MM_月_dd_日.string(from: date), for: .normal)
        }
    }
    
    // MARK: - Date
    
    let date_button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Font.title.b
        button.setTitleColor(Color.dark, for: .normal)
        return button
    }()
    
    @objc func date_action(_ sender: UIButton) {
        let key = KeyboardDate()
        key.delegate = self
        key.update(date: date)
        key.push()
    }
    
    func keyboard(_ board: Keyboard) {
        date = board.value as! Date
    }
    
    // MARK: - Switch
    
    let switch_button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "but_open"), for: .normal)
        button.tintColor = Color.gray.halftone
        return button
    }()
    
    @objc func switch_action(_ sender: UIButton) {
        let height: CGFloat = (self.frame.height == 90 ? 360 : 90)
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.size.height = height
            self.table.update_content_size()
        })
    }
}

// MARK: - cell

class CardCalendarViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
