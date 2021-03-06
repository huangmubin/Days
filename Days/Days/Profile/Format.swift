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
    
    /** yyyy年MM月dd日 */
    static let MM月dd日: DateFormatter = DateFormatter("MM月dd日")
    
    /** yyyy年MM月 */
    static let yyyy年MM月: DateFormatter = DateFormatter("yyyy年MM月")
    
    /** 上午下午 a hh:mm */
    static let a_hh_mm: DateFormatter = DateFormatter("a hh:mm")
    
    // MARK: - Date
    
    /** Date */
    class func day(_ date: Date, _ point: Date = Date()) -> String {
        let today = point.first(.day)
        let new = date.first(.day)
        switch (today.time1970 - new.time1970) / 86400 {
        case 0: return "今天"
        case -1: return "明天"
        case -2: return "后天"
        case 1: return "昨天"
        case 2: return "前天"
        default: return "\(new.day)日"
        }
    }
    
    /** Date */
    class func day_month(_ date: Date, _ point: Date = Date()) -> String {
        let today = point.first(.day)
        let new = date.first(.day)
        switch (today.time1970 - new.time1970) / 86400 {
        case 0: return "今天"
        case -1: return "明天"
        case -2: return "后天"
        case 1: return "昨天"
        case 2: return "前天"
        default:
            if today.year != new.year {
                return "\(new.year)年\(new.month)月\(new.day)日"
            } else {
                return "\(new.month)月\(new.day)日"
            }
        }
    }
    
    /** Date */
    class func day_month_week(_ date: Date, _ point: Date = Date()) -> String {
        let today = point.first(.day)
        let new = date.first(.day)
        switch (today.time1970 - new.time1970) / 86400 {
        case 0: return "今天"
        case -1: return "明天"
        case -2: return "后天"
        case 1: return "昨天"
        case 2: return "前天"
        default:
            let format = DateFormatter("M月d日 EEEE")
            return format.string(from: new)
        }
    }
    
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
    
    /** Timer splict */
    class func time_text(second: Int) -> String {
        let text = time(second: second).components(separatedBy: [" "])
        return "\(text[0])\(text[1])"
    }
    
    // MARK: - Clock
    
    /** hour:minute:second / minute:second */
    class func clock(_ second: Int) -> String {
        switch second {
        case 0 ..< 3600:
            return "\(time_00(second / 60)):\(time_00(second % 60))"
        case 3600 ..< 360000:
            return "\(time_00(second / 3600)):\(time_00((second % 3600) / 60)):\(time_00(second % 60))"
        default: return "00:00"
        }
    }
    
    /** 00:00 hour:minute */
    class func clock(second: Int) -> String {
        return time_00(second / 3600) + ":" + time_00(second % 3600 / 60)
    }
    
    /** */
    class func time_00(_ value: Int) -> String {
        return value > 9 ? "\(value)" : "0\(value)"
    }
    
}
