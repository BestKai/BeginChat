//
//  YKSessionService.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/8.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM
class YKSessionService: NSObject,AVIMClientDelegate {
    
    @discardableResult open class func defaultService() -> YKSessionService {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let defaultService = YKSessionService()
            private init(){}
        }
        /** @return Returns the default singleton instance. */
        return Static.defaultService
    }
    
    var client:AVIMClient?
    var clientId:String?
    
    open var connect = false
    
    
    func openWithClientId(clientId:String,callback: YKBooleanResultClosure?) {
        self.openWithClientId(clientId: clientId, force: true, callback: callback)
    }
    
    
    func openWithClientId(clientId:String,force:Bool,callback:YKBooleanResultClosure?) {
        self.openService()
        
        self.clientId = clientId
        
        self.client = AVIMClient.init(clientId: clientId, tag: clientId)
        self.client?.delegate = self
        
        let option: AVIMClientOpenOption = AVIMClientOpenOption()
        option.force = force
        
        client?.open(with: option, callback: { (succeeded, error) in
            
            self.updateConnectStatus()
            
            if callback != nil {
                callback!(succeeded, error)
            }
        })
    }
    
    
    
    func openService() {
        YKConversationService.defaultService()
        YKSessionService.defaultService()
        
    }
    
    
    func updateConnectStatus() {
        connect = client?.status == AVIMClientStatus.opened
    }
    
    
    
    func closeWithCallBack(callback:@escaping YKBooleanResultClosure) {
        
        client?.close(callback: { (succeeded, error) in
            if succeeded {
                AVUser.logOut()
                callback(succeeded, error)
                self.resetService()
            }
        })
    }
    
    
    
    //MARK: - ****** AVIMMessageDelegate ******
    func conversation(_ conversation: AVIMConversation, didReceiveCommonMessage message: AVIMMessage) {
        //自定义消息走
        self.recivedMessage(message: message as! AVIMTypedMessage, conversation: conversation)
    }
    
    func conversation(_ conversation: AVIMConversation, didReceive message: AVIMTypedMessage) {
        
        self.recivedMessage(message: message, conversation: conversation)
    }
    
    func conversation(_ conversation: AVIMConversation, didReceiveUnread unread: Int) {
        
    }
    
    
    func recivedMessage(message:AVIMTypedMessage, conversation:AVIMConversation) {
        
        if message.mediaType > 0 {
//            let userInfo = [YKMessageNotificationUserInfoConversationKey:conversation,yk]
            
        }
        
        self.receivedMessages(messages: [message], conversation: conversation, isUnReadMessage: true)
    }
    
    func receivedMessages(messages:Array<AVIMTypedMessage>,conversation:AVIMConversation, isUnReadMessage:Bool) {
        
        let userInfo = [YKMessageNotificationUserInfoConversationKey:conversation,YKDidReceiveMessagesUserInfoMessagesKey:messages] as [String : Any]
        
        let notificationName = NSNotification.Name(rawValue: YKNotificationMessageReceived)
        NotificationCenter.default.post(name:notificationName, object: userInfo)
    }
    
    
    func resetService() {
        
    }
    
}
