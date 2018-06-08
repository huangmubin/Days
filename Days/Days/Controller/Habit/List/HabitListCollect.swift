//
//  HabitListCollect.swift
//  Days
//
//  Created by Myron on 2018/6/8.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitListCollect: CollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var controller: HabitListController!
    var objs: [Habit] { return controller?.objs ?? [] }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HabitListCollect.Cell
        cell.show.value = 1
        cell.view_update(index: indexPath, controller: controller)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.performSegue(
            withIdentifier: "EditHabit",
            sender: controller.objs[indexPath.row]
        )
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    private var _landscape_size: CGSize?
    private var _portrait_size: CGSize?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            if let size = _landscape_size {
                print("collection size = \(size)")
                return size
            } else {
                let size = CGSize(
                    width: UIScreen.main.bounds.width / 2,
                    height: 80
                )
                _landscape_size = size
                print("collection size = \(size)")
                return size
            }
        } else {
            if let size = _portrait_size {
                print("collection size = \(size)")
                return size
            } else {
                let size = CGSize(
                    width: UIScreen.main.bounds.width,
                    height: 80
                )
                _portrait_size = size
                print("collection size = \(size)")
                return size
            }
        }
    }
    
}
