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
        
        var avimTypedMessage:AVIMTypedMessage?
        
        switch message.mediaType! {
        case .text:
           avimTypedMessage = AVIMTextMessage.init(text: message.text!, attributes: nil)
        case .image:
            
            let imagefile = AVFile.init(data: UIImageJPEGRepresentation(message.originPhoto!, 0.6)!)
            
            avimTypedMessage = AVIMImageMessage.init(text: nil, file:imagefile , attributes: nil)
        default:
            break
        }
        return avimTypedMessage!
    }
    
}
