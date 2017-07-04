//
//  YKChatMessageTableViewCell.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/27.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM


//MARK: - FontSize
let YK_MSG_CELL_NAME_FONTSIZE = 12.0//
let YK_MSG_CELL_TEXT_FONTSIZE = 15.0
let YK_MSG_CELL_TIME_FONTSIZE = 13.0


//MARK: - Color
let YK_MSG_CELL_NAME_TEXTCOLOR = UIColor.gray
let YK_MSG_CELL_TIME_BACKCOLOR = UIColor.init(red: 206/255.0, green: 206/255.0, blue: 206/255.0, alpha: 1)


//MARK: - Basic Constant
let YK_MSG_CELL_AVATAR_WH = 40.0

let YK_MSG_CELL_TIME_HEIGHT = 20.0
let YK_MSG_CELL_TIME_TOP_MARGIN = 8.0


let YK_MSG_CELL_AVATAR_NAME_MARGIN = 8.0
let YK_MSG_CELL_NAME_CONTENT_MARGIN = 2.0
let YK_MSG_CELL_EDGES_OFFSET = 10.0
let YK_MSG_CELL_CONTENT_BOTTOM_MARGIN = 12.0

let YK_MSG_CELL_TEXT_CONTENT_INSET = CGFloat((YK_MSG_CELL_AVATAR_WH - Double(UIFont.systemFont(ofSize: CGFloat(YK_MSG_CELL_TEXT_FONTSIZE)).lineHeight))/2.0)

let YK_MSG_CELL_BUBBLE_WIDTH = 6.0

let YK_MSG_CELL_MAXIMAGE_HEIGHT = CGFloat(200)


let YK_MSG_CELL_MAX_TEXT_WIDTH = ScreenWidth - 2 * (CGFloat(YK_MSG_CELL_AVATAR_WH) + CGFloat(YK_MSG_CELL_EDGES_OFFSET) + YK_MSG_CELL_TEXT_CONTENT_INSET)

class YKMessageContentView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        
        /*
         实现图片的裁剪
         */
        let maskLayer = CAShapeLayer.init()
        maskLayer.fillColor = UIColor.gray.cgColor
        maskLayer.contentsCenter = CGRect.init(x: 0.7, y: 0.7, width: 0.1, height: 0.1)
        maskLayer.contentsScale = UIScreen.main.scale
        self.layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mask?.frame = self.bounds.insetBy(dx: 0, dy: 0)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.layer.mask?.frame = self.bounds.insetBy(dx: 0, dy: 0)
        CATransaction.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class YKChatMessageTableViewCell: UITableViewCell {

    //MARK: - Parameters
    var message: YKMessage?
    var mediaType: AVIMMessageMediaType?
        
    var messageOwner: YKMessageOwnerType {
        
        if (self.reuseIdentifier?.contains(YKCellIdentifyOwnerSelf))! {
            return YKMessageOwnerType.BySelf
        }else if (self.reuseIdentifier?.contains(YKCellIdentifyOwnerOhter))! {
            return YKMessageOwnerType.ByOther
        }else if (self.reuseIdentifier?.contains(YKCellIdentifyOwnerSystem))! {
            return YKMessageOwnerType.BySystem
        }
        return YKMessageOwnerType.Unknown
    }
    
    var messageChatType: YKConversationType {
        
        if (self.reuseIdentifier?.contains(YKCellIdentifyGroup))! {
            return YKConversationType.Group
        }
        return YKConversationType.Single
    }
    
    
    var shouldShowName: Bool {
        let isMessageOwner = self.messageOwner == YKMessageOwnerType.BySelf
        
        let isMessageChatGroup = self.messageChatType == YKConversationType.Group
        
        if isMessageOwner&&isMessageChatGroup {
            self.nickNameLabel.isHidden = false
            return true
        }
        
        self.nickNameLabel.isHidden = true
        return false
    }
    
    
    
    //MARK: - SubViews
    lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel.init()
        nickNameLabel.font = UIFont.systemFont(ofSize: CGFloat(YK_MSG_CELL_NAME_FONTSIZE))
        nickNameLabel.textColor = YK_MSG_CELL_NAME_TEXTCOLOR
        return nickNameLabel
    }()
    
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView.init()
        return avatarImageView
    }()
    
    lazy var messageContentView: YKMessageContentView = {
        
        let messageContentView = YKMessageContentView.init()
        return messageContentView
    }()
    
    lazy var messageContentBackgroundImageView: UIImageView = {
        
        let backgroundImageView = UIImageView.init()
        
        return backgroundImageView
    }()
    
    //MARK: - Private Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        if message?.ownerType == YKMessageOwnerType.BySystem || message?.ownerType == YKMessageOwnerType.Unknown {
            return
        }
        
        if message?.ownerType == YKMessageOwnerType.BySelf {
            self.avatarImageView.snp.makeConstraints({ (make) in
                
                make.right.equalTo(-YK_MSG_CELL_EDGES_OFFSET)
                make.width.height.equalTo(YK_MSG_CELL_AVATAR_WH)
                make.top.equalTo(0)
            })
            
            self.nickNameLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(self.avatarImageView.snp.top)
                make.right.equalTo(self.avatarImageView.snp.left).offset(-YK_MSG_CELL_AVATAR_NAME_MARGIN)
                
                if !self.shouldShowName {
                    make.height.equalTo(0)
                }
            })
            self.messageContentView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.nickNameLabel.snp.bottom).offset(self.shouldShowName ? YK_MSG_CELL_NAME_CONTENT_MARGIN : 0)
               make.bottom.equalTo(-YK_MSG_CELL_CONTENT_BOTTOM_MARGIN)
                make.right.equalTo(self.nickNameLabel.snp.right).offset(4)
            })
        }else{
            self.avatarImageView.snp.makeConstraints({ (make) in
              make.left.equalTo(YK_MSG_CELL_EDGES_OFFSET)
                make.width.height.equalTo(YK_MSG_CELL_AVATAR_WH)
                make.top.equalTo(0)
            })
            
            self.nickNameLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(self.avatarImageView.snp.top)
                make.left.equalTo(self.avatarImageView.snp.right).offset(YK_MSG_CELL_AVATAR_NAME_MARGIN)
                
                if !self.shouldShowName {
                    make.height.equalTo(0)
                }
            })
            
            self.messageContentView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.nickNameLabel.snp.bottom).offset(self.shouldShowName ? YK_MSG_CELL_NAME_CONTENT_MARGIN : 0)
               make.bottom.equalTo(-YK_MSG_CELL_CONTENT_BOTTOM_MARGIN)
                make.left.equalTo(self.nickNameLabel.snp.left).offset(-4)
            })
        }
        
        self.messageContentBackgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.messageContentView)
        }
        
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
    //MARK: - Public Methods
    
    func setUpUI() {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = UIColor.clear
        
        self.mediaType = self.classMediaType()
        
    }
    
    func addGeneralView() {
        self.addSubview(self.nickNameLabel)
        self.addSubview(self.avatarImageView)
        self.addSubview(self.messageContentView)
        
        self.messageContentBackgroundImageView.image = YKMessageCellBubbleImageFactory.bubbleImageViewWith(owner:self.messageOwner,messageType:self.mediaType!,isHighlighted:false)
        
        self.messageContentBackgroundImageView.highlightedImage = YKMessageCellBubbleImageFactory.bubbleImageViewWith(owner:self.messageOwner,messageType:self.mediaType!,isHighlighted:true)
        
        self.messageContentView.layer.mask?.contents = self.messageContentBackgroundImageView.image?.cgImage
        self.insertSubview(self.messageContentBackgroundImageView, belowSubview: self.messageContentView)
    }

    
    
    public func configureCellWithData(message:Any) {
        self.message = message as? YKMessage
        
//        self.nickNameLabel.text = self.message?.sender?.name
        self.nickNameLabel.text = "123"

        self.avatarImageView.kf.setImage(with: self.message?.sender?.avatarURL, placeholder: UIImage.init(named: "avatar_placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    
    //MARK: - ****** 子类必须继承的方法 ******
    func classMediaType() -> AVIMMessageMediaType {
        return .none
    }
    
    
}
