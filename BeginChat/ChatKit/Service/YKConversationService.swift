//
//  YKConversationService.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/2.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM
import SQLite


class YKConversationService: NSObject {
    
    var currentConversationId: String?
    
    open var currentConversation:AVIMConversation?{
        didSet{
            YKConversationListService.defaultService().currentConversation = currentConversation
        }
    }
    
    var fetchConversationHandler: YKFetchConversationHandler?
    
    var database:Connection?
    
    
    //MARK: - ****** Swift Singleton ******
   @discardableResult open class func defaultService() -> YKConversationService {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let defaultService = YKConversationService()
            private init(){}
        }
        /** @return Returns the default singleton instance. */
        return Static.defaultService
    }
    
    
    
    lazy var client: AVIMClient? = {
        
        let client = YKSessionService.defaultService().client
        return client
    }()
    
    
    //MARK: - ****** Public Methods ******
    //创建会话
    func createCovnersationWithMembers(members:Array<String>, type:YKConversationType,unique:Bool,callback:@escaping AVIMConversationResultBlock) {
        
        var name:String = ""
        
        if type == YKConversationType.Group {
            name = "群聊"
        }else {
            
            for (_,memberId) in members.enumerated() {
                if memberId != YKSessionService.defaultService().clientId{
                    
                    if let temname = YKContactsService.defaultService().getLocalUserWithUserId(userId: memberId)?.name {
                        name = temname
                    }else{
                        name = memberId
                    }
                }
            }
        }
        
        var options:AVIMConversationOption = AVIMConversationOption.init(rawValue: 0)
        if unique {
            options = .unique
        }
        
        self.client?.createConversation(withName: name, clientIds: members, attributes: ["type" : type.rawValue], options: options, callback: callback)
    }
    
    //发送消息
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
    
    
    //MARK: - ****** 单聊 ******
    func fetchConversationWithPeerId(peerId:String, callback:@escaping AVIMConversationResultBlock) {
        
        if !YKSessionService.defaultService().connect {
            
            let tempError = NSError.init(domain: "YKConversationServiceErrorDomain", code: 0, userInfo: ["code":0,NSLocalizedDescriptionKey:String.init(format: "%@","Session not opened")])
            callback(nil,tempError)
            return
        }
        
        if peerId == YKSessionService.defaultService().clientId {
            let tempError = NSError.init(domain: "YKConversationServiceErrorDomain", code: 0, userInfo: ["code":0,NSLocalizedDescriptionKey:String.init(format: "%@","You cannot chat with yourself")])
            callback(nil,tempError)
            return
        }
        
        let members = [peerId,YKSessionService.defaultService().clientId]
        
        self.fetchConversationWithMembers(members: members as! Array<String>, type: YKConversationType.Single, callback: callback)
    }
    
    func fetchConversationWithMembers(members:Array<String>, type: YKConversationType, callback: @escaping AVIMConversationResultBlock) {
        self.createCovnersationWithMembers(members: members, type: type, unique: true, callback: callback)
    }
    
    //MARK: - ****** 群聊 ******
    func fetchConversationWithConversationId(conversationId:String,callBack:YKConversationResultClosure?) {
        
        let conversation:AVIMConversation? = client?.conversation(forId: conversationId)
        
        if conversation != nil {
            
            if callBack != nil {
                callBack!(conversation,nil)
            }
            return
        }
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
        
        let callback: AVIMArrayResultBlock = {(messages,error) in
            
            if closure != nil {
                closure!(messages,error)
            }
        }
        
        if timestamp == 0 {
            
            conversation.queryMessages(withLimit: UInt(limit), callback: callback)
        }else{
            conversation.queryMessages(beforeId: nil, timestamp: Int64(timestamp), limit: UInt(limit), callback: callback)
        }
    }
    
    
    //MARK: - ****** Conversation Local Data ******
    
    
    
    
    
    
    //MARK: - ****** Database ******
    func createDataBaseWithUserId(userId:String) {
        
        let dbPath = self.databasePathWithUserId(userId: userId)
        
        print("数据库路径\(dbPath)")
        
        database = try? Connection(dbPath)
        
        self.createContactDatabaseWithPath(path: dbPath)
        self.createSucceedMessageDatabaseWithPath(path: dbPath)
    }
    
    func createContactDatabaseWithPath(path:String) {
        
        let contacts = Table("Contact")
        
        let id = Expression<String>("id")
        let name  = Expression<String>("nickName")
        let avatar = Expression<String>("avatar")
        
        do {
            try database?.run(contacts.create(ifNotExists:true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(avatar)
            })
        } catch {
            print("出错了\(error)")
        }
    }
    
    func createSucceedMessageDatabaseWithPath(path:String)  {
        
        let conversationTab = Table("conversations")
        
        let id = Expression<String>("id")
        let data = Expression<Blob>("data")
        let unReadCount = Expression<Int>("unReadCount")
        let mentioned = Expression<Bool>("mentioned")
        let draft = Expression<String>("draft")
        
        do {
            try database?.run(conversationTab.create(ifNotExists:true){ t in
                t.column(id, primaryKey: true)
                t.column(data)
                t.column(unReadCount, defaultValue: 0)
                t.column(mentioned, defaultValue: false)
                t.column(draft)
            })
        } catch {
            print("出错了\(error)")
        }
    }
    
    
    func databasePathWithUserId(userId:String?) -> String {
        
        let libPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        
        let appId = YKChatKit.defaultKit().appId
        
        return libPath.appendingFormat("/com.BKChat.%@.%@db.sqlite3", appId ?? "TestId",userId ?? "TestUser")
    }
}

