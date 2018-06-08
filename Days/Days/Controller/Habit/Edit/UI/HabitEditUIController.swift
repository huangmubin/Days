//
//  HabitEditUIController.swift
//  Days
//
//  Created by Myron on 2018/5/29.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitEditUIController: BaseController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Date
    
    var habit: Habit!
    var is_image: Bool = true
    
    var images: [String] = [
        // 运动系列
        "habits_runner",
        "habits_cyclist",
        "habits_swimmer",
        "habits_yogi",
        
        "habits_bed",
        "habits_map",
        "habits_book_01",
        "habits_martini",
        "habits_book_02",
        "habits_micro",
        "habits_bookmarks",
        "habits_pet_01",
        "habits_bookshelf",
        "habits_roadsign",
        "habits_bulb",
        "habits_search",
        "habits_calculator",
        "habits_spoon",
        "habits_camera",
        "habits_sport_01",
        "habits_clover_01",
        "habits_sport_02",
//        "habits_cocktail",
        "habits_sport_03",
        "habits_coffee",
        "habits_sport_04",
        "habits_comment",
        "habits_sport_05",
        "habits_computer_01",
        "habits_star",
        "habits_iphone_01",
        "habits_stopwatch",
        "habits_keypad",

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
        
            // 红色
            0xF16D7A,
            0xF55066,
            0xFF4848,
            0xFF0035,
            
            // 橙色
            0xFF7A26,
            0xD75400,
            
            // 黄色
            0xFFFF00,
            0xFFED00,
            
            // 绿色
            0x61B500,
            0x356400,
            
            // 青色
            0x50E3C2,
            0x00AB85,
            
            // 蓝色
            0x1D86FF,
            0x004698,
            
            // 紫色
            0x9D2DFF,
            0x4E0093,
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
        if is_image {
            return CGSize(
                width: (collectionView.bounds.width - 30) / 4,
                height: (collectionView.bounds.width - 30) / 4
            )
        } else {
            return CGSize(
                width: (collectionView.bounds.width - 10) / 2,
                height: (collectionView.bounds.width - 30) / 4
            )
        }
    }
    
}
