//
//  YKCustomConversationViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/26.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM
//import IQKeyboardManagerSwift
import IQKeyboardManager

class YKCustomConversationViewController: YKConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configDataSources()
    }
    
    override func setUpUI() {
        super.setUpUI()
    }
    
    
    func configDataSources() {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
//        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.shared().isEnabled = true
        
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
