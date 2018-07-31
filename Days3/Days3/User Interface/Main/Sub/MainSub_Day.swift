//
//  MainDays_Day.swift
//  Days3
//
//  Created by 黄穆斌 on 2018/7/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

extension MainSub {
    class Day: View, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        // MARK: - Values
        
        weak var view: MainSub!
        
        var date_select: Date {
            get { return view.date }
            set { view.date = newValue }
        }
        private var dates: [Date] = (0 ..< 3).map({ Date().advance(.month, $0 - 1) })
        private var firsts: [Date] = (0 ..< 3).map({ Date().advance(.month, $0 - 1).first(.month).first(.weekday) })
        
        // MARK: - Action
        
        func reload() {
            collect.reloadData()
            collect.setContentOffset(CGPoint(
                x: collect.bounds.width,
                y: 0
            ), animated: false)
        }
        
        func update(_ date: Date) {
            for (i, v) in [-1, 0, 1].enumerated() {
                dates[i]  = date.advance(.month, v)
                firsts[i] = dates[i].first(.month).first(.weekday)
            }
        }
        
        // MARK: - Sub View
        
        let collect: CollectionView = CollectionView()
        
        // MARK: - View
        
        override func view_deploy() {
            super.view_deploy()
            addSubview(collect)
            collect.backgroundColor = UIColor.clear
            collect.dataSource = self
            collect.delegate   = self
            collect.isPagingEnabled = true
            collect.showsVerticalScrollIndicator = false
            collect.showsHorizontalScrollIndicator = false
            collect.register(MainSub.DayCell.self, forCellWithReuseIdentifier: "Cell")
            collect.register(MainSub.DayCell_Select.self, forCellWithReuseIdentifier: "Select")
            collect.register(MainSub.DayCell_Done.self, forCellWithReuseIdentifier: "Done")
            collect.flow?.scrollDirection = .horizontal
            collect.flow?.minimumLineSpacing = 0
            collect.flow?.minimumInteritemSpacing = 0
            
            DispatchQueue.main.async {
                self.reload()
            }
        }
        
        override func view_bounds() {
            super.view_deploy()
            collect.frame = bounds
            collect.flow?.itemSize = CGSize(
                width: bounds.width / 7,
                height: bounds.height / 6
            )
        }
        
        // MARK: - Collection
        
        private weak var cell_selected: DayCell?
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 3
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 7 * 6
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let row = (indexPath.row % 6) * 7 + (indexPath.row / 6)
            
            let month = dates[indexPath.section]
            let first = firsts[indexPath.section]
            let date = first.advance(.day, row)
            
            var cell: DayCell
            
            if date.date == date_select.date {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Select", for: indexPath) as! DayCell_Select
                cell_selected = cell
            } else if view.source?.days(status: date) == true {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Done", for: indexPath) as! DayCell_Done
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DayCell
            }
            
            cell.date = date
            cell.day.text = date.day.description
            cell.update(month: date.month == month.month)
            cell.view_update(index: indexPath, view: self)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            var indexes: [IndexPath] = []
            if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
                date_select = cell.date
                view.controller.update(date: cell.date, sender: view)
                indexes.append(indexPath)
            }
            if let cell = cell_selected {
                indexes.append(cell.index)
            }
            collectionView.reloadItems(at: indexes.sorted())
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if decelerate {
                isUserInteractionEnabled = false
            } else {
                self.scrollViewDidEndDecelerating(scrollView)
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let size = scrollView.bounds.width / 2
            if scrollView.contentOffset.x < size {
                update(dates[0])
                reload()
                view.year.update(dates[1])
            } else if scrollView.contentOffset.x > size * 3 {
                update(dates[2])
                reload()
                view.year.update(dates[1])
            }
            isUserInteractionEnabled = true
        }
    }
    
}

