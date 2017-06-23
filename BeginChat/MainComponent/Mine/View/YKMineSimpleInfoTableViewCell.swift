//
//  YKMineSimpleInfoTableViewCell.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/23.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit

class YKMineSimpleInfoTableViewCell: UITableViewCell {
    
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView.init()
        return avatarImageView
    }()
    
    lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel.init()
        nickNameLabel.font = UIFont.systemFont(ofSize: 16)
        return nickNameLabel
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.setUpUI()
    }
    
    func setUpUI() {
        self.contentView.addSubview(self.avatarImageView)
        
        self.contentView.addSubview(self.nickNameLabel)
        
        self.avatarImageView.snp.makeConstraints { (make) in
            
            make.left.top.equalTo(10)
            make.width.height.equalTo(48)
        }
        
        self.nickNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.avatarImageView.snp.centerY)
            make.left.equalTo(self.avatarImageView.snp.right).offset(8)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
