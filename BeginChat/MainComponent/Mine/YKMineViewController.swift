//
//  YKMineViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloud
import Kingfisher

class YKMineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var logoutButton: UIButton?
    
    var dataSources: Array = [Any]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))//去除顶部多余的空白
        tableView.tableFooterView = UIView.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.colorWithRGBValue(rgbValue: 0xfafafa)
        tableView.register(YKMineSimpleInfoTableViewCell.self, forCellReuseIdentifier: String(describing: YKMineSimpleInfoTableViewCell.self))
        tableView.register(YKMineOtherFuncTableViewCell.self, forCellReuseIdentifier: String(describing: YKMineOtherFuncTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "我"
        self.view.backgroundColor = UIColor.white
        
        self.initSubViews()
    }
    
    func initSubViews() {
        
        self.dataSources = [[["identify":"YKMineSimpleInfoTableViewCell"]],[["identify":"YKMineOtherFuncTableViewCell","title":"设置"]],[["identify":"YKMineOtherFuncTableViewCell","title":"退出登录"]]]
        
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionArray:Array<Any> = self.dataSources[section] as! Array
        
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionArray:Array<Any> = self.dataSources[indexPath.section] as! Array
        
        let tempDic:[String:Any] = sectionArray[indexPath.row] as! Dictionary
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tempDic["identify"]! as! String)
        
        if indexPath.section == 0 {
            
            let infoCell:YKMineSimpleInfoTableViewCell = cell as! YKMineSimpleInfoTableViewCell
            
            infoCell.nickNameLabel.text = YKUser.currentUser()?.name
            infoCell.avatarImageView.kf.setImage(with:  YKUser.currentUser()?.avatarURL)
        }else{
            cell?.textLabel?.text = (tempDic["title"] as! String)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 68
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        case 2:
            self.logout()
        default:
            break
        }
    }
    
    func logout() {
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
