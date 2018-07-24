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
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app.habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HabitListCollect.Cell
        cell.habit = app.habits[indexPath.row]
        cell.show.value = 1
        cell.view_update(index: indexPath, controller: controller)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller?.performSegue(
            withIdentifier: "HabitUnitEdit",
            sender: app.habits[indexPath.row]
        )
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    private var _landscape_size: CGSize?
    private var _portrait_size: CGSize?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            if let size = _landscape_size {
                return size
            } else {
                let size = CGSize(
                    width: UIScreen.main.bounds.width / 2,
                    height: 80
                )
                _landscape_size = size
                return size
            }
        } else {
            if let size = _portrait_size {
                return size
            } else {
                let size = CGSize(
                    width: UIScreen.main.bounds.width,
                    height: 80
                )
                _portrait_size = size
                return size
            }
        }
    }
    
    // MARK: - Animation
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HabitListCollect.Cell {
            if cell.habit.is_animation {
                cell.alpha = 0
                cell.layer.transform = CATransform3DMakeTranslation(0, bounds.height, 0)
                UIView.animate(withDuration: 0.25, delay: TimeInterval(indexPath.row) * 0.05, options: UIViewAnimationOptions.curveLinear, animations: {
                    cell.layer.transform = CATransform3DIdentity
                    cell.alpha = 1
                }, completion: nil) 
            }
        }
    }
    
}
