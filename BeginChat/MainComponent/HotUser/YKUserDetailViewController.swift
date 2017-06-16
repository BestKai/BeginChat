//
//  YKUserDetailViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/26.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloud

class YKUserDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    public var currentUser: AVUser?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: self.view.height), style: UITableViewStyle.plain)
        tableView.register(YKHotUserTableViewCell.classForCoder(), forCellReuseIdentifier: "YKHotUserTableViewCell")
        tableView.rowHeight = 60
        tableView.tableHeaderView = self.createTableHeaderView()
        tableView.tableFooterView = self.createTableFooterView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.init(colorLiteralRed: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = currentUser?.username
        
        self.initSubViews()
    }
    
    func initSubViews() {
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    
    //MARK: - UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YKHotUserTableViewCell") as! YKHotUserTableViewCell
        cell.setUser(user: currentUser)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 20))
        footerview.backgroundColor = UIColor.init(colorLiteralRed: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        return footerview
    }
    
    func createTableHeaderView() -> UIView {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 16))
        headerView.backgroundColor = UIColor.init(colorLiteralRed: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        return headerView
    }
    
    func createTableFooterView() -> UIView {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 48))
        let chatButton = UIButton.init(type: UIButtonType.custom)
        chatButton.setTitle("发消息", for: UIControlState.normal)
        chatButton.setTitleColor(UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1), for: UIControlState.normal)
        chatButton.layer.cornerRadius = 5
        chatButton.layer.masksToBounds = true
        chatButton.layer.borderColor = UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1).cgColor
        chatButton.layer.borderWidth = 0.5
        chatButton.addTarget(self, action: #selector(goToChatViewController), for: UIControlEvents.touchUpInside)
        footerView.addSubview(chatButton)
        
        chatButton.snp.makeConstraints { (make) in
            make.edges.equalTo(footerView).inset(UIEdgeInsetsMake(0, 16, 0, 16))
        }
        
        return footerView
    }
    
    func goToChatViewController() {
        
        let conversationVC = YKCustomConversationViewController.init(conversationId: "")
        
        self.navigationController?.pushViewController(conversationVC, animated: true)
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
