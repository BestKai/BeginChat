//
//  AppDelegate.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/21.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloud
import UserNotifications

//import IQKeyboardManagerSwift

import IQKeyboardManager

//Some App Key
let LCAppID = "FbA3He52KVxrdMf0y5qv0WEL-gzGzoHsz"
let LCClientKey = "O2FoUrynhG12xYoLrF1gJOMY"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        YKChatKit.defaultKit().setIdAndKey(appId: LCAppID, appKey: LCClientKey)
        
//        IQKeyboardManager.sharedManager().enable = true
//        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
//        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        self.registerForRemoteNotification()
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AVOSCloud.handleRemoteNotifications(withDeviceToken: deviceToken)
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func registerForRemoteNotification() {
        
        let unCenter:UNUserNotificationCenter = UNUserNotificationCenter.current()
        unCenter.delegate = self
        unCenter.requestAuthorization(options: [.badge,.badge,.sound]) { (granted, error) in
            
            if error != nil {
                print("出错了",error as Any)
            }else{
                print("授权成功")
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()//不加不会执行didRegisterForRemoteNotificationsWithDeviceToken方法
                })
            }
        }
        
        unCenter.getNotificationSettings { (setting) in
            
            if setting.authorizationStatus == UNAuthorizationStatus.notDetermined {
                print("未选择")
            }else if setting.authorizationStatus == UNAuthorizationStatus.denied {
                print("未授权")
            }else{
                print("已授权")
            }
        }
    }
    
    
    //MARK: - ****** UNUserNotificationCenterDelegate ******
    //在后台和启动之前收到推送内容，点击推送后执行的方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    //在前台收到推送内容，执行方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.sound)
    }
    
    
}




