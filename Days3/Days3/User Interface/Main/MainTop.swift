//
//  MainTop.swift
//  Days3
//
//  Created by Myron on 2018/7/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MainTop: TopView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Values
    
    weak var controller: MainController!
    var date: Date = Date()
    
    // MARK: - Action
    
    func reload() {
        date_view.reloadData()
        date_view.setContentOffset(
            CGPoint(x: CGFloat(center_index) * date_view.bounds.width, y: 0),
            animated: false
        )
    }
    
    override func left_action() {
        
    }
    
    override func right_action() {
        
    }
    
    private func update_sub_info(date: Date) {
        var texts = [Int: String]()
        let today = Date()
        texts[today.date] = "今天".language
        texts[today.advance(.day, -1).date] = "昨天".language
        texts[today.advance(.day, 1).date] = "明天".language
        
        sub_info.text = texts[date.date] ?? ""
    }
    
    // MARK: - Sub
    
    let date_view: CollectionView = CollectionView()
    let sub_info: UILabel = UILabel(
        text: "今天",
        font: Font.regular(12),
        color: Color.gray.dark,
        alignment: .center
    )
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        left.setImage(#imageLiteral(resourceName: "ui_bar_list"), for: .normal)
        right.setImage(#imageLiteral(resourceName: "ui_bar_append"), for: .normal)
        
        addSubview(date_view)
        date_view.backgroundColor = UIColor.clear
        date_view.showsHorizontalScrollIndicator = false
        date_view.register(MainTop.Cell.self, forCellWithReuseIdentifier: "Cell")
        date_view.flow?.scrollDirection = .horizontal
        date_view.flow?.minimumLineSpacing = 0
        date_view.flow?.minimumInteritemSpacing = 0
        date_view.dataSource = self
        date_view.delegate   = self
        
        addSubview(sub_info)
        
        DispatchQueue.main.async {
            self.reload()
        }
    }

    override func view_bounds() {
        super.view_bounds()
        let space: CGFloat = 10
        
        date_view.frame = CGRect(
            x: left.frame.maxX + space,
            y: edge.top,
            width: right.frame.minX - left.frame.maxX - space * 2,
            height: bounds.height - edge.top - edge.bottom
        )
        date_view.flow?.itemSize = date_view.frame.size
        
        let sub_info_y = bounds.height - 20
        sub_info.frame = CGRect(
            x: date_view.frame.minX,
            y: sub_info_y,
            width: date_view.frame.width,
            height: bounds.height - sub_info_y
        )
    }
    
    // MARK: - Collection
    
    private let cells: Int = 13
    private var center_index: Int { return cells / 2 + 1 }
    private let format: DateFormatter = DateFormatter("MM月dd日 EE".language)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainTop.Cell
        cell.view_update(index: indexPath, view: self)
        cell.info.text = format.string(from: date.advance(.day, indexPath.row - center_index))
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            let index = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
            update_sub_info(date: date.advance(.day, index - center_index))
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(date_view)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        date = date.advance(.day, index - center_index)
        controller.update(date: date)
        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentOffset = CGPoint(x: CGFloat(index) * scrollView.bounds.width, y: 0)
        }, completion: { _ in
            self.reload()
        })
    }
    
}

extension MainTop {
    class Cell: CollectionViewNormalCell {
        override func view_load() {
            super.view_load()
            info.font = Font.regular(20)
        }
    }
}

