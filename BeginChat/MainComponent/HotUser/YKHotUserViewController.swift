//
//  YKHotUserViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloud

class YKHotUserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    private var dataSources = [YKUser]()
    private var refreshControl:UIRefreshControl?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))//去除顶部多余的空白
 tableView.register(YKHotUserTableViewCell.classForCoder(), forCellReuseIdentifier: "YKHotUserTableViewCell")
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView.init()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl.init()
        self.refreshControl?.addTarget(self, action: #selector(refreshHotUserData), for: UIControlEvents.valueChanged)
        tableView.refreshControl = self.refreshControl
        
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "发现"
        self.view.backgroundColor = UIColor.white

        self.initSubViews()
        self.getDataSources()
    }

    func initSubViews() {
        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    
    @objc func refreshHotUserData() {
        self.getDataSources()
    }
    
    func getDataSources() {
        
        YKContactsService.defaultService().fetchContacts { (objects, error) in
            self.dataSources = objects as! [YKUser]
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YKHotUserTableViewCell", for: indexPath) as! YKHotUserTableViewCell
        cell.setUser(user: dataSources[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userDetailVC = YKUserDetailViewController.init()
        userDetailVC.hidesBottomBarWhenPushed = true
        userDetailVC.currentUser = dataSources[indexPath.row]
        self.navigationController?.pushViewController(userDetailVC, animated: true)
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
