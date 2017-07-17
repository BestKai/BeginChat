//
//  YKChatTextMessageCell.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/27.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM

class YKChatTextMessageCell: YKChatMessageTableViewCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    lazy var messageTextLabel: UILabel = {
        
        let messageTextlabel = UILabel.init()
        
        messageTextlabel.numberOfLines = 0
        
        messageTextlabel.font = UIFont.systemFont(ofSize: CGFloat(YK_MSG_CELL_TEXT_FONTSIZE))
        
        return messageTextlabel
    }()
    
    
    override func setUpUI() {
        super.setUpUI()
        
        self.messageContentView.addSubview(self.messageTextLabel)
        self.addGeneralView()
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        
        var textMessageEdgeInsets: UIEdgeInsets
        
        if self.messageOwner == .BySelf {
            
            textMessageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, CGFloat(8 + YK_MSG_CELL_BUBBLE_WIDTH))
            
        }else if self.message?.ownerType == YKMessageOwnerType.ByOther {
            
            textMessageEdgeInsets = UIEdgeInsetsMake(YK_MSG_CELL_TEXT_CONTENT_INSET, CGFloat(8 + YK_MSG_CELL_BUBBLE_WIDTH), YK_MSG_CELL_TEXT_CONTENT_INSET, 8)
        }else{
            textMessageEdgeInsets = UIEdgeInsetsMake(YK_MSG_CELL_TEXT_CONTENT_INSET, 8, YK_MSG_CELL_TEXT_CONTENT_INSET, 8)
        }
        self.messageTextLabel.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(YK_MSG_CELL_MAX_TEXT_WIDTH)
            make.edges.equalTo(self.messageContentView).inset(textMessageEdgeInsets)
        }
    }
    
    override func configureCellWithData(message: Any) {
        super.configureCellWithData(message: message)
        
        self.messageTextLabel.text = self.message?.text
    }
    

    //MARK: - protocol
   override  func classMediaType() -> AVIMMessageMediaType {
        
        return .text
    }
}
