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
        return controller?.objs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HabitListCollect.Cell
        cell.habit = controller.objs[indexPath.row]
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
    
    private var _display_animate: Bool = true
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if _display_animate {
            cell.alpha = 0
            cell.layer.transform = CATransform3DMakeTranslation(0, bounds.height, 0)
            UIView.animate(withDuration: 0.5, delay: TimeInterval(indexPath.row) * 0.1, options: UIViewAnimationOptions.curveLinear, animations: {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1
            }, completion: nil)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _display_animate = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        _display_animate = true
    }
}
