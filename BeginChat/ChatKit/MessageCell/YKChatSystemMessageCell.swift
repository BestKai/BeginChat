//
//  YKChatSystemMessageCell.swift
//  BeginChat
//
//  Created by bestkai on 2017/5/2.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM

class YKChatSystemMessageCell: YKChatMessageTableViewCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    lazy var systemMessageLabel: UILabel = {
        
        let systemMessageLabel = UILabel.init()
        
        systemMessageLabel.font = UIFont.systemFont(ofSize: CGFloat(YK_MSG_CELL_TIME_FONTSIZE))
        
        systemMessageLabel.textColor = UIColor.white
        
        return systemMessageLabel
    }()
    
    lazy var systemMessageContentView: UIView = {
        
        let systemContentView = UIView.init()
        
        systemContentView.backgroundColor = YK_MSG_CELL_TIME_BACKCOLOR
        systemContentView.layer.cornerRadius = 4
        systemContentView.layer.masksToBounds = true
        
        systemContentView.addSubview(self.systemMessageLabel)
        
        self.systemMessageLabel.snp.makeConstraints({ (make) in
            make.edges.equalTo(systemContentView).inset(UIEdgeInsetsMake(2,4,2,4))
        })
        
        return systemContentView
    }()
    
    override func setUpUI() {
        super.setUpUI()
        self.addSubview(self.systemMessageContentView)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        self.systemMessageContentView.snp.makeConstraints { (make) in
            make.top.equalTo(YK_MSG_CELL_TIME_TOP_MARGIN)
            make.bottom.equalTo(-YK_MSG_CELL_CONTENT_BOTTOM_MARGIN)
            make.centerX.equalTo(self.snp.centerX)
            make.width.lessThanOrEqualTo(YK_MSG_CELL_MAX_TEXT_WIDTH)
        }
    }
    
    override func configureCellWithData(message: Any) {
        super.configureCellWithData(message: message)
        
        self.systemMessageLabel.text = self.message?.text
        
        self.updateConstraintsIfNeeded()
    }
    
    //MARK: - protocol
    override func classMediaType() -> AVIMMessageMediaType {
        return kAVIMMessageMediaTypeSystem
    }
}
