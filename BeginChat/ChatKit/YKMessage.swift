//
//  YKMessage.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/26.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM
/*
 消息发送状态,自己发送的消息时有
 */
enum YKMessageSendStatus: Int {
    case None = 0
    case Sending
    case Sent
    case Delivered
    case Failed
    case Read
}

/*
 消息读取状态,自己接收消息时有
 */
enum YKMessageReadStatus: Int {
    case UnRead = 0
    case UnReading
    case Readed
}

/**
 *  消息拥有者类型
 */
enum YKMessageOwnerType: Int {
    case Unknown = 0
    case BySystem
    case BySelf
    case ByOther
}

/**
 *  消息聊天类型
 */
enum YKConversationType: Int {
    case Single = 0 //单聊
    case Group      //群聊
}

let kAVIMMessageMediaTypeSystem: AVIMMessageMediaType = -7


class YKUser {
    var userId: String?
    var name: String?
    var avatarURL: URL?
}


class YKBaseMessage {
    var messageId: String?
    var sender: YKUser?
    var sendStatus = YKMessageSendStatus.None
    var conversationId: String?
    var timestamp: TimeInterval?
    var ownerType = YKMessageOwnerType.Unknown
    var hasRead: Bool?
    var receiverHasRead: Bool?
    var ownerName: String?
    var chatType = YKConversationType.Single
    var cellHeight:CGFloat = 0.0
    
}



class YKMessage: YKBaseMessage {
    
    var serverMessageId: String?
    
    var text: String?
    
    var mediaType:AVIMMessageMediaType?
    
    override init() {
        super.init()
    }
    //MARK: - Text Message
    init(text:String, sender:YKUser?, timestamp:TimeInterval, serverMessageId:String?, chatType:YKConversationType) {
        super.init()
        self.text = text
        self.sender = sender
        self.timestamp = timestamp
        self.serverMessageId = serverMessageId
        self.mediaType = kAVIMMessageMediaTypeText
        self.chatCellHeight()
    }
    
    //MARK: - System Message
    init(systemText:String) {
        super.init()
        
        self.text = systemText
        self.mediaType = kAVIMMessageMediaTypeSystem
        self.ownerType = YKMessageOwnerType.BySystem
        self.chatCellHeight()
    }
    
    class func systemMessageWithTimestamp(timeStamp: TimeInterval) -> YKMessage {
        
        let date: Date = NSDate.init(timeIntervalSince1970: timeStamp/1000) as Date
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        
        let text = dateFormatter.string(from: date)
        
        let message = YKMessage.init(systemText: text)
        
        return message
    }
    
    
    
    class func messageWithAVIMTypedMessage(message:AVIMTypedMessage) -> YKMessage? {
        
        var ykMessage:YKMessage = YKMessage.init()
        let mediaType = message.mediaType
        
        switch mediaType {
        case kAVIMMessageMediaTypeText:
            
            let textMsg = message as! AVIMTextMessage
            ykMessage = YKMessage.init(text: textMsg.text!, sender: nil, timestamp: TimeInterval(textMsg.sendTimestamp), serverMessageId: textMsg.messageId, chatType: .Single)
        default: break
            
        }
        
        if YKSessionService.defaultService().clientId == message.clientId {
            ykMessage.ownerType = .BySelf
        }else{
            ykMessage.ownerType = .ByOther
        }
        ykMessage.sendStatus = YKMessageSendStatus.init(rawValue: Int(message.status.rawValue))!
        
        return ykMessage
    }
    
}


extension YKMessage {
    
    func chatCellHeight() {
        
        var textHeight = self.text?.height(fontSize: Float(YK_MSG_CELL_TEXT_FONTSIZE),maxWidth:Float(YK_MSG_CELL_MAX_TEXT_WIDTH))
        
        let showName = self.ownerType == YKMessageOwnerType.ByOther && self.chatType == YKConversationType.Group
        
        switch self.mediaType! {
        case kAVIMMessageMediaTypeText:
            
            if showName {
                textHeight! += (YK_MSG_CELL_NAME_FONTSIZE + 4.0)
            }
            
            self.cellHeight = CGFloat(textHeight!) + (YK_MSG_CELL_TEXT_CONTENT_INSET * 2) + CGFloat(YK_MSG_CELL_CONTENT_BOTTOM_MARGIN)
        
        case kAVIMMessageMediaTypeSystem:
            
            self.cellHeight = CGFloat(YK_MSG_CELL_TIME_HEIGHT + YK_MSG_CELL_CONTENT_BOTTOM_MARGIN + YK_MSG_CELL_TIME_TOP_MARGIN)
            
        default:
            self.cellHeight = 0
        }
    }
    
    func shouldDisplayTiemLabel(lastMessage:YKMessage?) -> Bool {
        if lastMessage == nil {
            return true
        }
        
        let interval: Int = Int(self.timestamp! - (lastMessage?.timestamp)!)
        
        let limitInterval = 60*3
        
        if interval > limitInterval {
            return true
        }
        return false
    }
}

