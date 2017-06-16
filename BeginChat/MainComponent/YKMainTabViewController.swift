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
    }

    func initSubViewControllers() {
        
        let chatListNav = UINavigationController.init(rootViewController: YKChatListViewController.init())
        chatListNav.title = "聊天"
        
        let hotUserNav = UINavigationController.init(rootViewController: YKHotUserViewController.init())
        hotUserNav.title = "发现"
        
        let mineNav = UINavigationController.init(rootViewController: YKMineViewController.init())
        mineNav.title = "我"
        
        self.viewControllers = [chatListNav,hotUserNav,mineNav]
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.black], for: UIControlState.selected)
    }

    
    func startService() {
        
        YKChatKit.defaultKit().openWithClientId(clientId:(AVUser.current()?.objectId)!) { (succeeded, error) in
            
            if error != nil {
                YKProgressView.showErrorMessage(errorMsg: "会话初始化失败", view: self.view)
            }
        }
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
