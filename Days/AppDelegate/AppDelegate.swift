//
//  AppDelegate.swift
//  Days
//
//  Created by Myron on 2018/5/22.
//  Copyright © 2018年 Myron. All rights reserved.
//

import UIKit

/**
 上传
    名字：生活记录本
    ID：App.Myron.Days
 测试使用
    名字：生活记录本
    ID：App.Myron.Days.Test
 临时开发
    名字：生活记录本 Debug
    ID：App.Myron.Days.Debug
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SQLite.default.open()
        
        let control = SQLiteLogsControl()
        SQLite.default.log = control
        
        SQLite.SQLiteLogs.create()
        SQLite.Habit.create()
        SQLite.HabitUnit.create()
//        SQLite.Event.create()
//        SQLite.EventUnit.create()
//        SQLite.Chart.create()
//        SQLite.ChartUnit.create()
//        SQLite.Diary.create()
//        SQLite.DiaryUnit.create()
        
        LocalNotification.authorization()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SQLite.default.open()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SQLite.default.close()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SQLite.default.close()
    }


}


// MARK: - 版本信息
/**
 > 1.0 上传日期 2018.06.03 发布日期 2018.06.10
 
 > 1.1 上传日期 2018.06.10 发布日期 2018.06.11
 * 隐藏了 里程碑，日记等功能，先专注并完善打卡功能的开发。
 * 增加了左滑到底快速打卡功能。
 * 习惯列表界面增加了日期选择功能。
 * 自动适配各种屏幕，在 iPhone 界面下只能竖屏，在 iPad 界面下只能横屏，iPhone Plus 可自由切换。同时对横屏界面做了一定的美观。
 * 调整了可选的图标和颜色列表。
 * 增加部分动画效果。
 * 修复 Bug.
 
 > 1.2 上传日期 2018.06.19 发布日期 2018.06.20
 * 修改了刷新动画。
 * 增加打卡列表页面。
 * 增加打卡内容编辑页面。
 * 修改习惯列表页面，短按为打开打卡列表，长按为打开习惯编辑。
 * 修复已知 Bug。
 
 > 1.3 上传日期 2018.07.09 发布日期
 * 修改了习惯列表界面的滑动菜单的按钮功能，改成：快速打卡、计时器/计步器、打卡列表。
 * 修改了习惯列表界面习惯单元的短按为打开打卡内容编辑界面。
 * 添加了 计时器/计步器界面。
 * 修改了 图标/颜色选择界面。
 * 更新新图标
 * 修复已知 Bug.
 */
