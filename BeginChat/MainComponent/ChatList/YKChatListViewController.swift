//
//  YKChatListViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import SnapKit

class YKChatListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataSources = Array<Any>()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "聊天"
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.tableView)
        self.setUpConstraint()
    }
    
    func setUpConstraint() {
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    //MARK: - ****** UITableViewDelegate && UITableViewDataSources ******
    
    
    
    
    
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
