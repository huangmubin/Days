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
    
    // MARK: - Formatter
    
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
    
    // MARK: - Timer
    
    /** Timer */
    class func time(second: Int) -> String {
        switch second {
        case 0 ..< 3600:
            if second % 60 == 0 {
                return "\(second / 60) 分钟"
            } else {
                return String(format: "%.1f 分钟", Double(second) / 60)
            }
        case 3600 ..< 86400:
            if second % 3600 == 0 {
                return "\(second / 3600) 小时"
            } else {
                return String(format: "%.1f 小时", Double(second) / 3600)
            }
        default:
            return "\(second / 86400) 天"
        }
    }
    
    /** Timer splict */
    class func time_unit(second: Int) -> (time: String, unit: String) {
        let text = time(second: second).components(separatedBy: [" "])
        return (text[0], text[1])
    }
    
}
