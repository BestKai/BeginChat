//
//  YKHotUserTableViewCell.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloud
import Kingfisher

class YKHotUserTableViewCell: UITableViewCell {

    var avatarImageView: UIImageView?
    var nickNameLabel: UILabel?
    
    var user: AVUser?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        avatarImageView = UIImageView.init()
        self.addSubview(avatarImageView!)
        
        nickNameLabel = UILabel.init()
        nickNameLabel?.font = UIFont.systemFont(ofSize: 16)
        nickNameLabel?.textColor = UIColor.init(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
        self.addSubview(nickNameLabel!)
        
        avatarImageView?.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo((avatarImageView?.snp.height)!)
        })
        
        nickNameLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo((avatarImageView?.snp.right)!).offset(8)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(-10)
        })
    }
    
    
    func setUser(user:AVUser?) {
        self.user = user
        
        avatarImageView?.kf.setImage(with: URL(string: "http://up.qqjia.com/z/face01/face06/facejunyong/junyong02.jpg"), placeholder: UIImage.init(named: "avatar_placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
        
        nickNameLabel?.text = (user?.username == nil) ? "未设置" : user?.username
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
