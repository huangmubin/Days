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

class CardCalendarView: CardBaseView, KeyboardDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Init
    
    override func view_deploy() {
        super.view_deploy()
        //clipsToBounds = true
        
        addSubview(date_button)
        addSubview(switch_button)
        addSubview(collect)
        
        date_button.addTarget(self, action: #selector(date_action(_:)), for: .touchUpInside)
        switch_button.addTarget(self, action: #selector(switch_action(_:)), for: .touchUpInside)
        
        collect.dataSource = self
        collect.delegate = self
        
        date = Date()
    }
    
    // MARK: - Frame
    
    override func view_bounds() {
        super.view_bounds()
        date_button.sizeToFit()
        date_button.frame = CGRect(
            x: 20, y: (80 - date_button.bounds.height) / 2,
            width: date_button.bounds.width, height: date_button.bounds.height
        )
        switch_button.frame = CGRect(
            x: bounds.width - 60, y: 10,
            width: 60, height: 60
        )
        
        collect.frame = CGRect(
            x: 20, y: 80,
            width: bounds.width - 40,
            height: (bounds.width - 40) / 7 * 6
        )
        let size_width = (bounds.width - 40) / 7
        if size_width != cell_size.width {
            cell_size = CGSize(width: size_width, height: size_width)
            collect.reloadData()
        }
    }
    
    // MARK: - Values
    
    /**  */
    weak var delegate: CardCalendarViewDelegate?
    
    /** 当前代表日期 */
    var date: Date = Date() {
        didSet {
            delegate?.cardCalendar(view: self, update: date)
            date_button.setTitle(Format.yyyy年MM月dd日.string(from: date), for: .normal)
            collect.reloadData()
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
    
    // MARK: - Collection
    
    let collect: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = CollectionView(frame: CGRect(x: 20, y: 80, width: 300, height: 300), collectionViewLayout: layout)
        view.layout = layout
        view.isScrollEnabled = false
        view.backgroundColor = Color.gray.dark
        view.register(CardCalendarView.Cell.self, forCellWithReuseIdentifier: "Cell")
        return view
    }()
    
    var cell_size = CGSize(
        width: (UIScreen.main.bounds.width - 40) / 7,
        height: (UIScreen.main.bounds.width - 40) / 7
    )
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCalendarView.Cell
        cell.view_update(index: indexPath, view: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cell_size
    }
    
}

// MARK: - cell

extension CardCalendarView {
    
    class Cell: CollectionViewCell {
        
        
        
        override func view_load() {
            addSubview(back)
            back.backgroundColor = Color.red.light
        }
        
        override func view_reload() {
            super.view_reload()
            back.frame = CGRect(x: 1, y: 1, width: bounds.width - 2, height: bounds.height - 2)
        }
        
        var back: View = View()
        
    }
    
}
