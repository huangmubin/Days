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
    
    var images_title: [String] = [
        "运动",
        "球类",
        "学习",
        "其他",
    ]
    
    var images: [[String]] = [
        [
            "v3_sport_bike",
            "v3_sport_default_92",
            "v3_sport_default_74",
            "v3_sport_default_96",
            "v3_sport_default_84",
            "v3_sport_run",
            "v3_sport_default_86",
            "v3_sport_swimming",
        ],
        [
            "v3_ball_default_75",
            "v3_ball_default_87",
            "v3_ball_default_79",
            "v3_ball_default_91",
            "v3_ball_default_83",
        ],
        [
            "v3_study_default_165",
            "v3_study_default_179",
            "v3_study_default_167",
            "v3_study_default_183",
            "v3_study_default_171",
            "v3_study_default_187",
            "v3_study_default_175",
        ],
        [
            "v3_other_default_120",
            "v3_other_default_155",
            "v3_other_default_128",
            "v3_other_default_62",
            "v3_other_default_147",
            "v3_other_default_64",
            "v3_other_default_154",
            "v3_other_default_68",
        ],
    ]
    
    var colors_title: [String] = [
        "红色",
        "橙色",
        "黄色",
        "绿色",
        "青色",
        "蓝色",
        "紫色",
    ]
    
    var colors: [[Int]] =
        [
            [
                // 红色
                0xF16D7A,
                0xF55066,
                0xFF4848,
                0xFF0035,
            ],[
                // 橙色
                0xFF7A26,
                0xD75400,
            ],[
                
                // 黄色
                0xFFFF00,
                0xFFED00,
            ],[
                
                // 绿色
                0x61B500,
                0x356400,
            ],[
                
                // 青色
                0x50E3C2,
                0x00AB85,
            ],[
                
                // 蓝色
                0x1D86FF,
                0x004698,
            ],[
                
                // 紫色
                0x9D2DFF,
                0x4E0093,
        ]
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
    
    @IBOutlet weak var top: TopView! {
        didSet {
            top.right_button.isHidden = true
        }
    }
    
    // MARK: - Collection
    
    @IBOutlet weak var collection: UICollectionView! {
        didSet {
            collection.register(
                HabitEditUIHeader.self,
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: "Header"
            )
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if is_image {
            return images.count
        } else {
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if is_image {
            return images[section].count
        } else {
            return colors[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HabitEditUICell
        if is_image {
            cell.value.setImage(
                Resource.image(images[indexPath.section][indexPath.row], habit.obj.color),
                for: .normal
            )
            cell.tintColor = habit.color
            cell.value.backgroundColor = Color.gray.thin
        } else {
            cell.value.setImage(nil, for: .normal)
            cell.value.backgroundColor = UIColor(colors[indexPath.section][indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: "Header",
            for: indexPath
        ) as! HabitEditUIHeader
        if is_image {
            view.title_label.text = images_title[indexPath.section]
        } else {
            view.title_label.text = colors_title[indexPath.section]
        }
        view.view_update(section: indexPath.section, controller: self)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if is_image {
            habit.obj.image = images[indexPath.section][indexPath.row]
        } else {
            habit.obj.color = colors[indexPath.section][indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width,
            height: 60
        )
    }

    
}
