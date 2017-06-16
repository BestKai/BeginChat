//
//  YKChatListViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import SnapKit

class YKChatListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "聊天"
        self.view.backgroundColor = UIColor.white
        
        if #available(iOS 9.0, *) {
            let stackView = UIStackView.init()
            
            stackView.backgroundColor = UIColor.black
            
            let label = UILabel.init()
            
            label.numberOfLines = 2;
            
            label.text = "anlkdnfkansdnfoiansdi";
            label.backgroundColor = UIColor.red
            
            stackView.addSubview(label)

            self.view.addSubview(stackView)
            
            stackView.snp.makeConstraints { (make) in
                make.left.equalTo(80)
                make.right.equalTo(-80)
                make.top.equalTo(80)
                
                make.height.equalTo(50)
                //            make.height.equalTo(50)
            }

            
            label.snp.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(0)
            }

            
            
            let label02 = UILabel.init()
            
            label02.numberOfLines = 2;
            
            label02.text = "anlkdnfkansdnfoiansdi";
            label02.backgroundColor = UIColor.red
            
            self.view.addSubview(label02)
            
            label02.snp.makeConstraints { (make) in
                make.left.equalTo(80)
                make.right.equalTo(-80)
                make.top.equalTo(stackView.snp.bottom).offset(50)
            }
            

        } else {
            // Fallback on earlier versions
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
