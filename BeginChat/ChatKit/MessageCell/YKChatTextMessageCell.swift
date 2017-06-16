//
//  YKChatTextMessageCell.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/27.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM

class YKChatTextMessageCell: YKChatMessageTableViewCell , YKChatCellSubclassMedaiTypeProtocol {

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
        
        self.addGeneralView()
        
        self.messageContentView.addSubview(self.messageTextLabel)
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        
        var textMessageEdgeInsets: UIEdgeInsets
        
        if self.message?.ownerType == YKMessageOwnerType.BySelf {
            
            textMessageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, CGFloat(8 + YK_MSG_CELL_BUBBLE_WIDTH))
            
        }else if self.message?.ownerType == YKMessageOwnerType.ByOther {
            
            textMessageEdgeInsets = UIEdgeInsetsMake(8, CGFloat(8 + YK_MSG_CELL_BUBBLE_WIDTH), 8, 8)
        }else{
            textMessageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
        }
        
        self.messageTextLabel.snp.makeConstraints { (make) in
            
            make.width.lessThanOrEqualTo(YK_MSG_CELL_MAX_TEXT_WIDTH)
            make.edges.equalTo(self.messageContentView).inset(textMessageEdgeInsets)
        }
    }
    
    override func configureCellWithData(message: Any) {
        super.configureCellWithData(message: message)
        
        self.messageTextLabel.text = self.message?.text
        
        self.updateConstraintsIfNeeded()
    }
    

    //MARK: - protocol
    class func classMediaType() -> AVIMMessageMediaType {
        
        return kAVIMMessageMediaTypeText
    }
}
