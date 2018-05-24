//
//  Format.swift
//  Days
//
//  Created by Myron on 2018/5/23.
//  Copyright © 2018年 Myron. All rights reserved.
//

import Foundation

/** Format Profile */
class Format {
    
    /** yyyyMMdd */
    static let yyyyMMdd: DateFormatter = DateFormatter("yyyyMMdd")
    
    /** yyyy-MM-dd */
    static let yyyy_MM_dd: DateFormatter = DateFormatter("yyyy-MM-dd")
    
    /** yyyy 年 MM 月 dd 日 */
    static let yyyy_年_MM_月_dd_日: DateFormatter = DateFormatter("yyyy 年 MM 月 dd 日")
    /** yyyy年MM月dd日 */
    static let yyyy年MM月dd日: DateFormatter = DateFormatter("yyyy年MM月dd日")
    
    /** ee hh:mm */
    static let ee_hh_mm: DateFormatter = DateFormatter("ee hh:mm")
    
}
