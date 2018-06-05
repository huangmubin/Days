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
        
        if !UserDefaults.standard.bool(forKey: "SQLite.create.Databases") {
            SQLite.SQLiteLogs.create()
            
            SQLite.Habit.create()
            SQLite.HabitUnit.create()
            SQLite.Event.create()
            SQLite.EventUnit.create()
            SQLite.Chart.create()
            SQLite.ChartUnit.create()
            SQLite.Diary.create()
            SQLite.DiaryUnit.create()
            UserDefaults.standard.set(true, forKey: "SQLite.create.Databases")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        SQLite.default.open()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SQLite.default.close()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SQLite.default.close()
    }


}


// MARK: - 版本信息
/**
 > 1.0 上传日期 2018.06.03 发布日期 2018.06.10
 > 1.1 上传日期 2018.06.10 发布日期
 1. Debug: 添加新习惯时出现的闪退
 2. Debug: 打卡后展示界面界面没有实时更新
 3. Debug: 里程碑事件显示错误
 */
