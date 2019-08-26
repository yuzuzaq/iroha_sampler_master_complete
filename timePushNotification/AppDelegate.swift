//
//  AppDelegate.swift
//  timePushNotification
//
//  Created by tatsumi kentaro on 2018/08/30.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let realm = try! Realm()
    //realmオブジェクト
    var contentsArray = [dateData]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // ローカル通知の確認
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    print("通知許可")
                    
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                    
                } else {
                    print("通知拒否")
                }
            })
            
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("きてるよ")
        //アプリがになった時に呼ばれる
        var trigger: UNNotificationTrigger
        let content = UNMutableNotificationContent()
        var notificationTime = DateComponents()
        contentsArray = [dateData]()
        //realmから登録した全てのオブジェクトから取り出す
        let data = realm.objects(AlertData.self)
        // ここで全てを一つずつ取り出しcontentsArrayに追加
        data.forEach { (diff) in
            contentsArray.append(dateData(title: diff.title, contents: diff.contents, month: diff.month, day: diff.day))
        }
        var num = 0
//        contentsArrayを一つずつ取り出し通知のトリガーを登録
        for contents in contentsArray{
            print(contents.month)
            print(contents.day)
            notificationTime.day = Int(contents.day)
            notificationTime.month = Int(contents.month)
            
            notificationTime.hour = 23
            notificationTime.minute = 22
            trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
            
            // 通知内容の設定
            content.title = contents.title
            content.body = contents.contents
            content.sound = UNNotificationSound.default()
            
            // 通知スタイルを指定
            let request = UNNotificationRequest(identifier: "uuid\(num)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print(num)
            num += 1
        }
        
        // トリガー設定

        // 通知をセット
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

