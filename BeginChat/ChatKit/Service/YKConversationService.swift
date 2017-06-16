//
//  YKConversationService.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/2.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM


public typealias AVProgressClosure = (NSInteger) -> Void
public typealias YKBooleanResultClosure = (Bool,Error?) -> Void
public typealias YKVoidClosure = () -> Void
public typealias YKArrayResultBlock = ([Any]?, Error?) -> Void

public typealias YKFetchConversationHandler = (AVIMConversation?,YKConversationViewController?) -> Void


public typealias YKConversationResultClosure = (AVIMConversation?,Error?) -> Void


class YKConversationService: NSObject {
    
    var currentConversationId: String?
    
    open var conversation:AVIMConversation?
    
    var fetchConversationHandler: YKFetchConversationHandler?
    
    
    //MARK: - ****** Swift Singleton ******
    open class func defaultService() -> YKConversationService {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let defaultService = YKConversationService()
            private init(){}
        }
        /** @return Returns the default singleton instance. */
        return Static.defaultService
    }
    
    
    
    lazy var client: AVIMClient? = {
        
        var client = self.client
        
        if client == nil {
            client = YKSessionService.defaultService().client
        }
        return client
    }()
    
    
    //MARK: - ****** Public Methods ******
    func sendMessage(message: AVIMTypedMessage, conversation: AVIMConversation, progressClosure: @escaping AVProgressClosure, callBack: YKBooleanResultClosure?) {
        
        let options = AVIMMessageOption.init()
        options.receipt = true
        
        self.sendMessage(message: message, conversation: conversation, options: options, progressClosure: progressClosure, callBack:callBack)
    }
    
    func sendMessage(message: AVIMTypedMessage, conversation: AVIMConversation,
             options:AVIMMessageOption,
     progressClosure:AVProgressClosure?, callBack Closure: YKBooleanResultClosure?) {
        let currentUser = AVUser.current()
        
        var attributes = Dictionary<String, Any>()
        
        if ((currentUser?.username) != nil) {
            attributes["username"] = currentUser?.username
        }
        
        if message.attributes != nil {
            
            for (key,value) in attributes {
                message.attributes?.updateValue(value, forKey: key)
            }
        }else{
            message.attributes = attributes
        }
        
        conversation.send(message, option: options, progressBlock: progressClosure) { (succceed, error) in
            
            guard Closure == nil else {
                Closure!(succceed,error);
                return
            }
        }
    }
    
    
    func fetchConversationWithConversationId(conversationId:String,callBack:YKConversationResultClosure?) {
        
        self.fetchConversationsWithConversationIds(conversationIds: [conversationId]) { (objects, error) in
            
            if error == nil {
                
                if objects?.count == 0 {
                    
                    let tempError = NSError.init(domain: "YKConversationServiceErrorDomain", code: 0, userInfo: ["code":0,NSLocalizedDescriptionKey:String.init(format: "conversation of %@ are not exists",conversationId)])
                    if callBack != nil {
                        callBack!(objects?.first as? AVIMConversation,tempError)
                    }
                }else{
                    if callBack != nil {
                    callBack!(objects?.first as? AVIMConversation,error)
                    }
                }
            }else{
                if callBack != nil {
                    callBack!(nil,error)
                }
            }
        }
    }
    
    
    func fetchConversationsWithConversationIds(conversationIds:Array<String>,callBack:YKArrayResultBlock?) {
        
        let query:AVIMConversationQuery = YKSessionService.defaultService().client!.conversationQuery()
        query.whereKey("objectId", containedIn: conversationIds)
        query.limit = conversationIds.count
        query.option = AVIMConversationQueryOption.withMessage
        query.cacheMaxAge = 0
        
        query.findConversations { (obejcts, error) in
            if callBack != nil {
                callBack!(obejcts,error)
            }
        }
    }
    
    
    func queryTypedMessagesWithConversation(conversation:AVIMConversation, timestamp:Int, limit:Int, closure:AVIMArrayResultBlock?) {
        
        let callback: AVIMArrayResultBlock = {(messages:[Any]?,error:Error) -> Void in
            
            if closure != nil {
                closure!(messages,error)
            }
        } as! AVIMArrayResultBlock
        
        if timestamp == 0 {
            
            conversation.queryMessages(withLimit: UInt(limit), callback: callback)
        }else{
            conversation.queryMessages(beforeId: nil, timestamp: Int64(timestamp), limit: UInt(limit), callback: callback)
        }
    }
    
}
