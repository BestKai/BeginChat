//
//  YKConversationListCell.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/21.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM
import SnapKit

class YKConversationListCell: UITableViewCell {
    
    var conversation:AVIMConversation? {
        didSet{
            self.handleUI()
        }
    }
    
    
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView.init()
        return avatarImageView
    }()
    
    lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel.init()
        nickNameLabel.font = UIFont.systemFont(ofSize: 16)
        nickNameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: UILayoutConstraintAxis.horizontal)
        return nickNameLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel.init()
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.textColor = UIColor.colorWithRGBValue(rgbValue: 0x9b9b9b)
        return messageLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel.init()
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        timeLabel.textColor = UIColor.colorWithRGBValue(rgbValue: 0xb2b2b2)
        return timeLabel
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
        super.init(style: style, reuseIdentifier:reuseIdentifier)
        self.setUpUI()
    }
    
    func setUpUI() {
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.nickNameLabel)
        self.contentView.addSubview(self.messageLabel)
        self.contentView.addSubview(self.timeLabel)
        
        self.avatarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(9)
            make.width.height.equalTo(50)
        }
        
        self.nickNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.top).offset(4)
            make.left.equalTo(avatarImageView.snp.right).offset(8)
            make.right.greaterThanOrEqualTo(timeLabel.snp.left).offset(20)
        }
        
        self.messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(6)
            make.left.equalTo(nickNameLabel.snp.left)
            make.right.equalTo(-20)
        }
        
        self.timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nickNameLabel.snp.centerY)
            make.right.equalTo(-10)
        }
    }
    
    
    func handleUI() {
        
        self.avatarImageView.image = UIImage.init(named: "avatar_placeholder")
        
        self.nickNameLabel.text = conversation?.name != nil ? conversation?.name : "未知对方"
        
        var message:String
        
        let lastMessage:AVIMMessage? = conversation?.lastMessage
        
        if (conversation?.lastMessage?.isKind(of: AVIMTypedMessage.self))! {
            let typedMessage:AVIMTypedMessage? = lastMessage as? AVIMTypedMessage
            
            switch typedMessage?.mediaType {
            case .text?:
                let textMsg:AVIMTextMessage = typedMessage as! AVIMTextMessage
                message = textMsg.text!
            case .image?:
                message = "[图片]"
            case .location?:
                message = "[地理位置]"
            default:
                message = "未知消息类型"
            }
        }else{
            message = "未知消息类型"
        }
        self.messageLabel.text = message
        
        let dateFormate = DateFormatter.init()
        dateFormate.dateFormat = "YYYY/MM/dd"
        
        self.timeLabel.text = dateFormate.string(from: (conversation?.updateAt)!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
