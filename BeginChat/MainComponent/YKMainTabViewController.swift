//
//  YKMainTabViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM
class YKMainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        
        self.initSubViewControllers()
        
        self.startService()
        
        self.updateCurrentUserInfo()
    }

    func initSubViewControllers() {
        
        let chatListNav = UINavigationController.init(rootViewController: YKChatListViewController.init())
        chatListNav.tabBarItem.title = nil
        chatListNav.tabBarItem.image = UIImage.init(named: "tabbar_chat_unselected")?.withRenderingMode(.alwaysOriginal)
        chatListNav.tabBarItem.selectedImage = UIImage.init(named: "tabbar_chat_selected")?.withRenderingMode(.alwaysOriginal)
        chatListNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        
        let hotUserNav = UINavigationController.init(rootViewController: YKHotUserViewController.init())
        hotUserNav.tabBarItem.title = nil
        hotUserNav.tabBarItem.image = UIImage.init(named: "tabbar_discover_unselected")?.withRenderingMode(.alwaysOriginal)
        hotUserNav.tabBarItem.selectedImage = UIImage.init(named: "tabbar_discover_selected")?.withRenderingMode(.alwaysOriginal)
        hotUserNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)

        let mineNav = UINavigationController.init(rootViewController: YKMineViewController.init())
        mineNav.tabBarItem.title = nil
        mineNav.tabBarItem.image = UIImage.init(named: "tabbar_mine_unselected")?.withRenderingMode(.alwaysOriginal)
        mineNav.tabBarItem.selectedImage = UIImage.init(named: "tabbar_mine_selected")?.withRenderingMode(.alwaysOriginal)
        mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)

        self.viewControllers = [chatListNav,hotUserNav,mineNav]
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.black], for: UIControlState.selected)
    }

    
    func startService() {
        YKChatKit.defaultKit().openWithClientId(clientId:(AVUser.current()?.objectId)!) { (succeeded, error) in
            
            if error != nil {
                YKProgressView.showErrorMessage(errorMsg: "会话初始化失败", view: self.view)
            }else{
                print("会话初始化成功")
                self.conversationListVCRefreshData()
            }
        }
    }
    
    func updateCurrentUserInfo() {
        AVUser.current()?.fetchInBackground({ (user, error) in
            print("信息更新成功")
        })
    }
    
    func conversationListVCRefreshData() {
        
        let viewControllers = self.viewControllers
        
        let firstNavVC:UINavigationController = viewControllers?.first as! UINavigationController
        
        let rootViewController = firstNavVC.viewControllers.first
        
        if (rootViewController?.isKind(of: YKChatListViewController.self))! {
            
            let chatVC:YKChatListViewController = rootViewController as! YKChatListViewController
            chatVC.loadConversationData(isrefresh: false)
        }
    }
    
    
    //MARK: - ****** UITabbarDelegate ******
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let index = tabBar.items?.index(of: item)
        
        let selectedItemView = tabBar.subviews[index! + 1]
        
        let selectedImageView = selectedItemView.subviews.first as! UIImageView
        
        selectedImageView.zoom(animatedTime: 0.2, maxScale: 1.3, minScale: 0.9)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
