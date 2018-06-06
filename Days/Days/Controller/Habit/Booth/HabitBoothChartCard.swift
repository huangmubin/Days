//
//  HabitBoothChartCard.swift
//  Days
//
//  Created by Myron on 2018/5/30.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class HabitBoothChartCard: CardBaseView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Value
    
    /** Date */
    var chart: Chart!
    
    /** Space title to container */
    var space: CGFloat = 10
    
    // MARK: - Deploy
    
    override func reload() {
        super.reload()
        if chart.obj.is_habit {
            if chart.habit.obj.is_time {
                count.text = Format.time_text(
                    second: chart.units(date: chart.date.date).obj.length
                )
            } else {
                count.text = chart.units(date: chart.date.date).obj.length.description + "次"
            }
        } else {
            count.text = chart.units(date: chart.date.date).obj.length.description
        }
        day.text = Format.day(chart.date)
        date_button.setTitle(
            Format.yyyy年MM月.string(from: chart.date),
            for: .normal
        )
        collection.reloadData()
    }
    
    override func view_deploy() {
        super.view_deploy()
        container.addSubview(name)
        container.addSubview(detail)
        container.addSubview(count)
        container.addSubview(day)
        container.addSubview(goal)
        
        container.addSubview(collection)
        collection.dataSource = self
        collection.delegate = self
        
        container.addSubview(last_button)
        container.addSubview(next_button)
        container.addSubview(date_button)
        last_button.addTarget(self, action: #selector(last_action), for: .touchUpInside)
        next_button.addTarget(self, action: #selector(next_action), for: .touchUpInside)
        date_button.addTarget(self, action: #selector(date_action), for: .touchUpInside)
    }
    
    override func view_bounds() {
        super.view_bounds()
        container.frame = CGRect(
            x: edge.left, y: edge.top,
            width: bounds.width - edge.left - edge.right,
            height: bounds.height - edge.top - edge.bottom
        )
        
        name.sizeToFit()
        name.frame = CGRect(
            x: 20, y: 16,
            width: container.bounds.width - 30 - 60,
            height: name.frame.height
        )
        detail.frame = CGRect(
            x: name.frame.minX,
            y: name.frame.maxY,
            width: name.frame.width,
            height: detail.sizeThatFits(CGSize(width: name.frame.width, height: 1000)).height
        )
        
        let y = (name.frame.height + detail.frame.height) / 2 + name.frame.minY
        
        count.frame = CGRect(
            x: name.frame.maxX,
            y: y - 16, width: 60, height: 16
        )
        day.frame = CGRect(
            x: count.frame.minX,
            y: count.frame.maxY,
            width: count.frame.width,
            height: count.frame.height
        )
        
        collection.frame = CGRect(
            x: 10, y: max(detail.frame.maxY, day.frame.maxY) + space,
            width: container.frame.width - 20,
            height: container.frame.height - detail.frame.maxY - space - 40
        )
        
        goal.frame = CGRect(
            x: 0,
            y: collection.frame.height  / 6 + collection.frame.minY,
            width: container.bounds.width,
            height: 1
        )
        
        last_button.frame = CGRect(
            x: 10,
            y: collection.frame.maxY ,
            width: 60,
            height: 40
        )
        
        date_button.frame = CGRect(
            x: last_button.frame.maxX,
            y: last_button.frame.minY,
            width: container.bounds.width - 20 - 120,
            height: last_button.frame.height
        )
        
        next_button.frame = CGRect(
            x: date_button.frame.maxX,
            y: date_button.frame.minY,
            width: 60,
            height: date_button.frame.height
        )
    }
    
    // MARK: - note
    
    let name: UILabel = Views.Label.normal("图表名字", alignment: .right)
    let detail: UILabel = Views.Label.hint(small: "", line: 0)
    let count: UILabel = Views.Label.hint(small: "10分钟")
    let day: UILabel = Views.Label.hint(small: "今天")
    
    // MARK: - Line
    
    let goal: UIView = {
        let view = UIView()
        view.backgroundColor = Color.white
        return view
    }()
    
    // MARK: - Collection
    
    let collection: CollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let view = CollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout
        )
        view.layout = layout
        view.register(
            HabitBoothChartCard.Cell.self,
            forCellWithReuseIdentifier: "Cell"
        )
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chart.date.days(.month)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HabitBoothChartCard.Cell
        let date = chart.date.first(.month)
        let cell_date = date.advance(.day, indexPath.row)
        let units = chart.units(date: cell_date.date)
        
        // UI
        cell.column.backgroundColor = chart.habit.color
        
        // Select
        cell.select.isHidden = (cell_date.day != chart.date.day)
        
        // Value
        cell.value = CGFloat(units.obj.length) / CGFloat(chart.obj.goal)
        
        // Days
        let days = date.days(.month)
        if days % 2 == 0 {
            if indexPath.row < days - 6 {
                cell.day.isHidden = indexPath.row % 2 == 1
            } else if indexPath.row > days - 6 {
                cell.day.isHidden = indexPath.row % 2 == 0
            } else {
                cell.day.isHidden = true
            }
        } else {
            cell.day.isHidden = indexPath.row % 2 == 1
        }
        cell.view_update(index: indexPath, view: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let days = CGFloat(chart.date.days(.month))
        return CGSize(
            width: collectionView.bounds.width / days,
            height: collectionView.bounds.height
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let first = chart.date.first(.month)
        chart.date = first.advance(.day, indexPath.row)
        reload()
    }
    
    // MARK: - Buttons
    
    let last_button: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_last"))
    let next_button: UIButton = Views.Button.system(image: #imageLiteral(resourceName: "but_next"))
    let date_button: UIButton = Views.Button.hint("2018年10月")
    
    @objc func last_action() {
        chart.date = chart.date.advance(.month, -1)
        reload()
    }
    @objc func next_action() {
        chart.date = chart.date.advance(.month, 1)
        reload()
    }
    @objc func date_action() {
        let key = KeyboardDate()
        key.delegate = self
        key.update(date: habit.date)
        key.update(title: "输入日期")
        key.push()
    }
    
    override func keyboard(_ board: Keyboard) -> String? {
        if let date = board.value as? Date {
            chart.date = date
            return nil
        } else {
            return "日期不合法"
        }
    }
}

// MARK: - Cell

extension HabitBoothChartCard {
    
    class Cell: CollectionViewCell {
        
        var value: CGFloat = 0
        
        // MARK: - Load
        
        override func view_load() {
            super.view_load()
            clipsToBounds = false
            addSubview(day)
            addSubview(column)
            addSubview(select)
        }
        
        override func view_reload() {
            super.view_reload()
            day.text = (index.row + 1).description
            day.sizeToFit()
            day.center = CGPoint(
                x: bounds.width / 2,
                y: bounds.height - 10
            )
            
            
            let h = (bounds.height - 20) / 1.2 * min(value, 1.2)
            column.frame = CGRect(
                x: bounds.width * 0.1,
                y: bounds.height - 20 - h,
                width: bounds.width * 0.8,
                height: h
            )
            column.layer.cornerRadius = bounds.width * 0.4
            
            
            select.frame = CGRect(
                x: bounds.width * 0.2,
                y: column.frame.minY - bounds.width * 0.7,
                width: bounds.width * 0.6,
                height: bounds.width * 0.6
            )
            select.layer.cornerRadius = select.frame.width / 2
        }
        
        // MARK: - Views
        
        let day: UILabel = Views.Label.hint(small: "10")
        
        let column: UIView = {
            let view = UIView()
            view.backgroundColor = Color.gray.dark
            return view
        }()
        
        let select: UIView = {
            let view = UIView()
            view.backgroundColor = Color.red.light
            return view
        }()
    }
    
}
