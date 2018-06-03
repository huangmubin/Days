//
//  HabitEditUIController.swift
//  Days
//
//  Created by Myron on 2018/5/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditUIController: ViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Date
    
    var habit: Habit!
    var is_image: Bool = true
    
    var images: [String] = [
        "alarm-clock",
        "bicycle",
        "book",
        "computer",
        "cooking",
        "improvement",
        "karaoke",
        "wallet",
//        "alarm-clock",
//        "bicycle",
//        "book",
//        "computer",
//        "cooking",
//        "improvement",
//        "karaoke",
//        "wallet",
//        "alarm-clock",
//        "bicycle",
//        "book",
//        "computer",
//        "cooking",
//        "improvement",
//        "karaoke",
//        "wallet",
//        "alarm-clock",
//        "bicycle",
//        "book",
//        "computer",
//        "cooking",
//        "improvement",
//        "karaoke",
//        "wallet",
    ]
    
    var colors: [Int] = [
        0x3DAFFD,
        0xFF0035,
        0x50E3C2,
        0x45538C,
//        0x3DAFFD,
//        0xFF0035,
//        0x50E3C2,
//        0x45538C,
//        0x3DAFFD,
//        0xFF0035,
//        0x50E3C2,
//        0x45538C,
//        0x3DAFFD,
//        0xFF0035,
//        0x50E3C2,
//        0x45538C
    ]
    
    // MARK: - Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if is_image {
            top.title.setTitle("图标", for: .normal)
        } else {
            top.title.setTitle("颜色", for: .normal)
        }
    }
    
    // MARK: - Top
    
    @IBOutlet weak var top: TopView!
    
    // MARK: - Collection
    
    @IBOutlet weak var collection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if is_image {
            return images.count
        } else {
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HabitEditUICell
        if is_image {
            cell.value.setImage(
                Resource.image(images[indexPath.row], habit.obj.color),
                for: .normal
            )
            cell.tintColor = habit.color
            cell.value.backgroundColor = Color.gray.thin
        } else {
            cell.value.setImage(nil, for: .normal)
            cell.value.backgroundColor = UIColor(colors[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if is_image {
            habit.obj.image = images[indexPath.row]
        } else {
            habit.obj.color = colors[indexPath.row]
        }
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (collectionView.bounds.width - 30) / 4,
            height: (collectionView.bounds.width - 30) / 4
        )
    }
    
}
