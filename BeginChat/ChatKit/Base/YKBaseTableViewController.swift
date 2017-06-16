//
//  YKBaseTableViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/26.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit

public class YKBaseTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    public var tableView: UITableView?
    public var dataSources = [Any]()
    public var allowScrollToBottom = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.setUpUI()
    }
    
    func setUpUI() {
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: self.view.height), style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView.init()
        tableView?.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tableView?.backgroundColor = UIColor.clear
        self.view.addSubview(tableView!)
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
    
    func scrollToBottomAnimated(animated:Bool) {
        if !self.allowScrollToBottom {
            return
        }
        
        let rows = self.tableView?.numberOfRows(inSection: 0)
        
        if rows!>0 {
            self.tableView?.scrollToRow(at: IndexPath.init(row: rows!-1, section: 0), at: UITableViewScrollPosition.bottom, animated: animated)
        }
    }
    
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
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
