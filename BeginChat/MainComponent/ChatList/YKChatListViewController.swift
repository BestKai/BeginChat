//
//  YKChatListViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import SnapKit
import AVOSCloudIM

class YKChatListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataSources = Array<Any>()
    var refreshControl:UIRefreshControl?
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 68
        tableView.register(YKConversationListCell.self, forCellReuseIdentifier: String(describing: YKConversationListCell.self))
        tableView.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl.init()
        self.refreshControl?.addTarget(self, action: #selector(refreshConversationData), for: UIControlEvents.valueChanged)
        tableView.refreshControl = self.refreshControl
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "聊天"
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.tableView)
        self.setUpConstraint()
        
        self.loadConversationData(isrefresh: false)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshConversationList), name: NSNotification.Name(rawValue: YKNotificationMessageReceived), object: nil)
    }
    
    func setUpConstraint() {
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
   @objc func refreshConversationData() {
        self.loadConversationData(isrefresh: true)
    }
    
    func loadConversationData(isrefresh:Bool) {
        YKConversationListService.defaultService().fetchRelationConversationFromServer(isRefresh: isrefresh) { (objects, error) in
            if objects != nil {
                self.dataSources = objects!
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc func refreshConversationList() {
        
    }
    
    
    //MARK: - ****** UITableViewDelegate && UITableViewDataSources ******
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:YKConversationListCell = tableView.dequeueReusableCell(withIdentifier: String(describing: YKConversationListCell.self)) as! YKConversationListCell
        cell.conversation = self.dataSources[indexPath.row] as? AVIMConversation
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversation:AVIMConversation? = self.dataSources[indexPath.row] as? AVIMConversation
        
        let conversationVC:YKCustomConversationViewController
        if !(conversation?.transient)! {
            conversationVC = YKCustomConversationViewController.init(conversationId: conversation?.conversationId, peerId:nil)
        }else{
            conversationVC = YKCustomConversationViewController.init(conversationId: nil, peerId:conversation?.conversationId)
        }
        
        conversationVC.refreshConversationClosure = {(refreshConversation) in
            
            self.refreshConversation(conversation: refreshConversation, index: indexPath.row)
        }
        
        conversationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    
    func refreshConversation(conversation:AVIMConversation,index:Int) {
        
            self.dataSources[0] = conversation as Any
            self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
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
