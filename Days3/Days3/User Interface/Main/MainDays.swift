//
//  MainDays.swift
//  Days3
//
//  Created by Myron on 2018/7/28.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

protocol MainDaysDateSource: class {
    func days(status date: Date) -> CGFloat?
}

class MainDays: View {
    
    // MARK: - Values
    
    weak var controller: MainController!
    weak var source: MainDaysDateSource?
    
    var date: Date = Date()
    
    // MARK: - Action
    
    func reload() {
        year.reload()
        day.reload()
    }
    
    // MARK: - Sub View
    
    let year: MainDays.Year = Year()
    let week: MainDays.Week = Week()
    let day : MainDays.Day  = Day()
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        addSubview(year)
        year.view = self
        
        addSubview(week)
        
        addSubview(day)
        day.view = self
    }
    
    override func view_bounds() {
        super.view_deploy()
        year.frame = CGRect(
            x: 0, y: 0,
            width: bounds.width,
            height: 60
        )
        week.frame = CGRect(
            x: 10,
            y: year.frame.maxY,
            width: bounds.width - 20,
            height: 40
        )
        day.frame  = CGRect(
            x: week.frame.minX,
            y: week.frame.maxY,
            width: week.frame.width,
            height: week.frame.width / 7 * 6
        )
    }
    
}

// MARK: - Year

extension MainDays {
    class Year: View {
        
        // MARK: - Values
        
        weak var view: MainDays!
        private let format = DateFormatter("yyyy年MM月".language)
        private var date: Date = Date()
        
        // MARK: - Action
        
        func reload() {
            years.forEach({
                if $0.tag == 0 {
                    $0.setTitle(
                        format.string(from: date),
                        for: .normal
                    )
                } else {
                    $0.setTitle(
                        "\(date.year + $0.tag)",
                        for: .normal
                    )
                }
            })
        }
        
        func update(_ date: Date) {
            self.date = date
            reload()
        }
        
        @objc func year_change(_ sender: UIButton) {
            if sender.tag == 0 {
                
            } else {
                date = date.advance(.year, sender.tag)
                view.day.update(date)
                reload()
            }
        }
        
        // MARK: - Sub View
        
        let years: [UIButton] = (0 ..< 3).map({
            let view = UIButton()
            view.tag = $0 - 1
            return view
        })
        
        // MARK: - View
        
        override func view_deploy() {
            super.view_deploy()
            years.forEach({
                $0.setTitleColor($0.tag == 0 ? Color.black : Color.gray.dark, for: .normal)
                $0.titleLabel?.font = $0.tag == 0 ? Font.normal : Font.small
                $0.addTarget(self, action: #selector(year_change(_:)), for: .touchUpInside)
                addSubview($0)
            })
        }
        
        override func view_bounds() {
            super.view_deploy()
            let width = bounds.height + 40
            years[0].frame = CGRect(
                x: 0, y: 0,
                width: width,
                height: bounds.height
            )
            years[2].frame = CGRect(
                x: bounds.width - width, y: 0,
                width: width,
                height: bounds.height
            )
            years[1].frame = CGRect(
                x: years[0].frame.maxX,
                y: 0,
                width: years[2].frame.minX - years[0].frame.maxX,
                height: bounds.height
            )
        }
    }
}

// MARK: - Week

extension MainDays {
    class Week: View {
        // MARK: - Values
        
        private let font: UIFont = Font.normal
        private let color: UIColor = Color.gray.dark
        
        // MARK: - Sub View
        
        let weeks: [UILabel] = (0 ..< 7).map({
            let view = UILabel()
            view.tag = $0
            return view
        })
        
        // MARK: - View
        
        override func view_deploy() {
            super.view_deploy()
            let texts = [
                "日".language,
                "一".language,
                "二".language,
                "三".language,
                "四".language,
                "五".language,
                "六".language,
            ]
            weeks.forEach({
                $0.text = texts[$0.tag]
                $0.font = font
                $0.textColor = color
                $0.textAlignment = .center
                $0.sizeToFit()
                addSubview($0)
            })
        }
        
        override func view_bounds() {
            super.view_deploy()
            let space = bounds.width / 7
            let x = space * 0.5
            let y = bounds.height / 2
            weeks.forEach({
                $0.center = CGPoint(
                    x: x + space * CGFloat($0.tag),
                    y: y
                )
            })
        }
    }
}

// MARK: - Days
extension MainDays {
    class Day: View, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        // MARK: - Values
        
        weak var view: MainDays!
        
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
            collect.register(MainDays.DayCell.self, forCellWithReuseIdentifier: "Cell")
            collect.register(MainDays.DayCell_Select.self, forCellWithReuseIdentifier: "Select")
            collect.register(MainDays.DayCell_Done.self, forCellWithReuseIdentifier: "Done")
            collect.register(MainDays.DayCell_None.self, forCellWithReuseIdentifier: "None")
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
            } else if let status = view.source?.days(status: date) {
                if status < 1 {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "None", for: indexPath) as! DayCell_None
                } else {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Done", for: indexPath) as! DayCell_Done
                }
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DayCell
            }
            
            if date.week == 1 && indexPath.row % 6 % 2 == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "None", for: indexPath) as! DayCell_None
            }
            if date.week == 2 && indexPath.row % 6 % 2 == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Done", for: indexPath) as! DayCell_Done
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
    
    class DayCell: CollectionViewCell {
        
        var date: Date = Date()
        
        // MARK: - Sub Views
        
        let day: UILabel = UILabel(
            text: "10",
            font: Font.regular(18),
            color: Color.black,
            alignment: .center
        )
        
        // MARK: - Actions
        
        func update(month value: Bool) {
            if value {
                day.textColor = Color.black
            } else {
                day.textColor = Color.gray.halftone
            }
        }
        
        // MARK: - Load
        
        override func view_load() {
            super.view_load()
            addSubview(day)
        }
        
        override func view_reload() {
            super.view_reload()
            day.frame = bounds
        }
    }
    
    class DayCell_Select: DayCell {
        
        let select: UIView = UIView()
        
        // MARK: - Load
        
        override func update(month value: Bool) {
            super.update(month: value)
            select.isHidden = !value
            if value {
                day.textColor = Color.white
            }
        }
        
        override func view_load() {
            addSubview(select)
            day.textColor = Color.white
            select.backgroundColor = Color.black
            
            super.view_load()
        }
        
        override func view_reload() {
            super.view_reload()
            let size = min(bounds.width, bounds.height) - 4
            let x = (bounds.width - size) / 2
            let y = (bounds.height - size) / 2
            select.frame = CGRect(
                x: x, y: y,
                width: size,
                height: size
            )
            select.layer.cornerRadius = size / 2
        }
    }
    
    class DayCell_Status: DayCell {
        
        var image: UIImageView = UIImageView()
        
        override func view_load() {
            super.view_load()
            self.day.font = Font.regular(12)
            addSubview(image)
        }
        
        override func view_reload() {
            super.view_reload()
            let size = min(bounds.width, bounds.height) - 4
            let x = (bounds.width - size) / 2
            let y = (bounds.height - size) / 2
            image.frame = CGRect(
                x: x, y: y,
                width: size,
                height: size
            )
        }
        
    }
    
    class DayCell_Done: DayCell_Status {
        
        override func view_load() {
            super.view_load()
            image.image = #imageLiteral(resourceName: "ui_calendar_day_done")
        }
        
        override func view_reload() {
            super.view_reload()
            day.center = CGPoint(
                x: image.frame.width / 2,
                y: image.frame.height / 4 + image.frame.minY
            )
        }
        
    }
    
    class DayCell_None: DayCell_Status {
        
        let shape = CAShapeLayer()
        var value: CGFloat = 0.8
        
        override func view_load() {
            super.view_load()
            image.image = #imageLiteral(resourceName: "ui_calendar_day_none")
            image.mask = UIView()
            image.mask?.layer.addSublayer(shape)
            
            image.layer.addSublayer(shape)
        }
        
        override func view_reload() {
            super.view_reload()
            image.mask?.frame = image.bounds
            shape.frame = image.bounds
            
            let path = UIBezierPath(
                arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                radius: bounds.width * 0.1,
                startAngle: 0,
                endAngle: CGFloat.pi * 2,
                clockwise: true
            )
            path.lineCapStyle = CGLineCap.round
            path.lineWidth = image.bounds.width * 0.4
            shape.path = path.cgPath
            shape.lineWidth = 10
            shape.strokeColor = UIColor.red.cgColor
            
        }
        
    }
}
