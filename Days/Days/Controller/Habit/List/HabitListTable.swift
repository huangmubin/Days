//
//  HabitListTable.swift
//  Days
//
//  Created by Myron on 2018/5/24.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

//class HabitListTable: TableView, UITableViewDataSource, UITableViewDelegate {
//
//    weak var controller: HabitListController!
//    var objs: [Habit] { return controller?.objs ?? [] }
//    
//    // MARK: - UITableView DateSource
//    
//    override func numberOfRows(inSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return objs.count
//        //return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HabitListCell
//        cell.view_update(index: indexPath, controller: controller)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        /*
//        controller.performSegue(
//            withIdentifier: "OpenBooth",
//            sender: controller.objs[indexPath.row]
//        )
//         */
//        controller.performSegue(
//            withIdentifier: "EditHabit",
//            sender: controller.objs[indexPath.row]
//        )
//    }
//}
