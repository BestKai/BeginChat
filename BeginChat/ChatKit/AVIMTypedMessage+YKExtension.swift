//
//  AVIMTypedMessage+YKExtension.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/7.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM


extension AVIMTypedMessage {
    
    static func yk_messageWithYKMessage(message:YKMessage) -> AVIMTypedMessage {
        
        var avimTypedMessage:AVIMTypedMessage  = AVIMTypedMessage()
        
        switch message.mediaType! {
        case kAVIMMessageMediaTypeText:
           avimTypedMessage = AVIMTextMessage.init(text: message.text!, attributes: nil)
        default:
            break
        }
        return avimTypedMessage
    }
}
