//
//  YKMineViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloud

class YKMineViewController: UIViewController {

    var logoutButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "我"
        self.view.backgroundColor = UIColor.white
        self.initSubViews()
    }
    
    func initSubViews() {
        logoutButton = UIButton.init(type: UIButtonType.custom)
        logoutButton?.backgroundColor = UIColor.red
        logoutButton?.addTarget(self, action: #selector(logout), for: UIControlEvents.touchUpInside)
        self.view.addSubview(logoutButton!)
        
        logoutButton?.snp.makeConstraints({ (make) in
            make.size.equalTo(100)
            make.center.equalTo(self.view.snp.center)
        })
    }
    
   @objc func logout() {
        YKBeginChatTool.logOutFromViewController(viewController: self)
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
