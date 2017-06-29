//
//  YKChatImageMessageCell.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/27.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM

class YKChatImageMessageCell: YKChatMessageTableViewCell {
    
    lazy var messageImageView: UIImageView = {
        let messageImageView = UIImageView.init()
        return messageImageView
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setUpUI() {
        super.setUpUI()
        self.addGeneralView()
        self.messageContentView.addSubview(self.messageImageView)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        var textMessageEdgeInsets = UIEdgeInsets.zero
        
        if self.message?.ownerType == YKMessageOwnerType.BySelf {
            
            textMessageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, CGFloat(8 + YK_MSG_CELL_BUBBLE_WIDTH))
            
        }else if self.message?.ownerType == YKMessageOwnerType.ByOther {
            
            textMessageEdgeInsets = UIEdgeInsetsMake(YK_MSG_CELL_TEXT_CONTENT_INSET, CGFloat(8 + YK_MSG_CELL_BUBBLE_WIDTH), YK_MSG_CELL_TEXT_CONTENT_INSET, 8)
        }
        
        self.messageImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(textMessageEdgeInsets)
            
            make.height.lessThanOrEqualTo(200)
        }
    }
    
    override func configureCellWithData(message: Any) {
        super.configureCellWithData(message: message)
        
        repeat {
            if self.message?.thumbnailPhoto != nil {
                self.messageImageView.image = self.message?.thumbnailPhoto
                break
            }
            
            let imageLocalPath = self.message?.photoPath
            
            let isHttpPath = imageLocalPath?.hasPrefix("http")
            
            if imageLocalPath != nil && !isHttpPath! {
                var data:Data?
                do {
                    try data = Data.init(contentsOf: URL.init(fileURLWithPath: imageLocalPath!))
                
                } catch {}
                
                var image:UIImage?
                
                if data != nil {
                    image = UIImage.init(data:data!)
                }
                
                let resizeImae = image?.imageByResizeToSize(size: CGSize.init(width: 200, height: 200))
                
                self.messageImageView.image = resizeImae
                
                self.message?.thumbnailPhoto = resizeImae
                self.message?.originPhoto = image
                break
            }
            
            if self.message?.originPhotoUrl != nil {
                
                self.messageImageView.kf.setImage(with: self.message?.originPhotoUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageUrl) in
                    
                    DispatchQueue.main.async {
                        if image != nil {
                            self.message?.originPhoto = image
                            
                            self.message?.thumbnailPhoto = image?.imageByResizeToSize(size: CGSize.init(width: 200, height: 200))
                        }
                    }
                })
            }
        }while false
        
        
        self.updateConstraintsIfNeeded()
    }
    
    override func classMediaType() -> AVIMMessageMediaType {
        return .image
    }

}
