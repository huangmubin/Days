//
//  MainContent.swift
//  Days3
//
//  Created by Myron on 2018/7/27.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

class MainContent: View, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Values
    
    weak var controller: MainController!
    
    // MARK: - Action
    
    func reload() {
        table.reloadData()
    }
    
    // MARK: - Sub View
    
    let table: TableView = TableView()
    
    // MARK: - View
    
    override func view_deploy() {
        super.view_deploy()
        
        addSubview(table)
        table.register(MainContent.Cell.self, forCellReuseIdentifier: "Cell")
        table.register(MainContent.Header.self, forHeaderFooterViewReuseIdentifier: "Header")
        table.dataSource = self
        table.delegate   = self
    }
    
    override func view_bounds() {
        super.view_deploy()
        table.frame = CGRect(
            x: 10, y: 20,
            width: bounds.width - 20,
            height: bounds.height - 40
        )
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainContent.Cell
        cell.view_update(index: indexPath, view: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? MainContent.Header
        view?.frame.size = CGSize(width: tableView.bounds.width, height: 60)
        view?.view_update(section: section, view: self)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 60
    }
    
}

