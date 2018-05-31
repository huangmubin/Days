//
//  ChartUnit.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

class ChartUnit {
    
    // MARK: - Init
    
    let obj: SQLite.ChartUnit
    
    weak var chart: Chart!
    
    init(_ chart: Chart) {
        self.chart = chart
        self.obj   = SQLite.ChartUnit()
        self.obj.belong = chart.obj.id
    }
    
    init(_ chart: Chart, _ obj: SQLite.ChartUnit) {
        self.chart = chart
        self.obj   = obj
    }
    
}
