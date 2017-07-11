//
//  YKConversationListService.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/20.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM
import SQLite

var refreshedFromServer = false

class YKConversationListService: NSObject {
    
    @discardableResult open class func defaultService() -> YKConversationListService {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let defaultService = YKConversationListService()
            private init(){}
        }
        /** @return Returns the default singleton instance. */
        return Static.defaultService
    }
    
    //MARK: - ****** Parmeters ******
    
    lazy var recentConversationDic: Dictionary<String,AVIMConversation> = {
        let recentConversationDic = Dictionary<String, AVIMConversation>.init()
        return recentConversationDic
    }()
    
    var conversationTable:Table?
    var currentConversation:AVIMConversation?
    
    
    override init() {
        super.init()
        conversationTable = Table("conversations")
        self.fetchConversatioinFromLocal(closure: nil)
    }
    
    func refreshConversation(closure:@escaping YKArrayResultBlock) {
        
        let allConversations = [AVIMConversation](recentConversationDic.values)
        
        if !allConversations.isEmpty {
        if refreshedFromServer == false && YKSessionService.defaultService().connect {
            var conversaionIds = Array<String>.init()
            for (conversatioinId,_) in recentConversationDic{
                conversaionIds.append(conversatioinId)
            }
            
            YKConversationListService.defaultService().fetchConversationWithConversationIds(conversationIds: conversaionIds, closuer: { (objects, error) in
                if error != nil {
                    
                    DispatchQueue.main.async(execute: {
                        closure(allConversations,nil)
                    })                }else{
                    refreshedFromServer = true
                    
                    YKConversationListService.defaultService().updateRecentConversations(conversations: objects as! Array<AVIMConversation>, shouldRefreshWhenFinshed: true)
                    DispatchQueue.main.async(execute: {
                        closure(objects,error)
                    })                }
            })
        }else{
            
            DispatchQueue.main.async(execute: {
                closure(allConversations,nil)
            })
        }
        }else{
            self.fetchRelationConversationFromServer(isRefresh: true, callback: { (objects, error) in
                
                DispatchQueue.main.async(execute: {
                    closure(objects,error)
                })
            })
        }
    }
    
    
    
    func fetchConversatioinFromLocal(closure:AVIMArrayResultBlock?) {
        
        let database = YKConversationService.defaultService().database
        do {
            for conversation  in try database!.prepare(conversationTable!) {
                let data = conversation.get(Expression<Data>("data"))
                let unreadCount = conversation.get(Expression<Int>("unReadCount"))
                
                let conver:AVIMConversation = AVIMConversation.getConversatioinWithData(data: data)!
                
                conver.yk_unReadCount = unreadCount
                
                recentConversationDic.updateValue(conver, forKey: conver.conversationId!)
            }
        } catch {
            print("\(error)")
        }
    }
    
    
    func fetchRelationConversationFromServer(isRefresh:Bool, callback:@escaping AVIMArrayResultBlock) {
        
        let client = YKSessionService.defaultService().client
        
        let conversationQuery = client?.conversationQuery()
        
        conversationQuery?.limit = 1000
        
        conversationQuery?.cachePolicy = .networkOnly
            
        conversationQuery?.option = .withMessage
        conversationQuery?.findConversations(callback: { (array, error) in
            
            if array != nil {
                self.insertRecentConversations(conversations: array as! Array<AVIMConversation>, shouldRefreshWhenFinished: false)
                
            }
            callback(array,error)
        })
    }
    
    
    func fetchConversationById(conversationId:String,closuer:@escaping AVIMConversationResultBlock)  {
        
        let client = YKSessionService.defaultService().client
        
        let conversationQuery = client?.conversationQuery()
        
     conversationQuery?.option = .withMessage
 conversationQuery?.getConversationById(conversationId, callback: closuer)
    }
    
    func fetchConversationWithConversationIds(conversationIds:Array<String>,closuer:@escaping AVIMArrayResultBlock) {
        let client = YKSessionService.defaultService().client
        
        let conversationQuery = client?.conversationQuery()
        
        conversationQuery?.whereKey("objectId", containedIn: conversationIds)
        conversationQuery?.limit = conversationIds.count
        conversationQuery?.option = .withMessage
        conversationQuery?.cachePolicy = .ignoreCache
        conversationQuery?.findConversations(callback: closuer)
    }
    //MARK: - ****** Update ******
    func updateRecentConversations(conversations:Array<AVIMConversation>,shouldRefreshWhenFinshed:Bool) {
        
        for (_,conversation) in conversations.enumerated() {
            
            if let cacheConversation = recentConversationDic[conversation.conversationId!] {
                
                conversation.yk_unReadCount = cacheConversation.yk_unReadCount
                
                recentConversationDic.updateValue(conversation, forKey: conversation.conversationId!)
                
                let updateQuery = conversationTable?.filter(Expression<String>("id") == conversation.conversationId!).update(Expression<Data>("data") <- conversation.converToData())
                
                do {
                    try YKConversationService.defaultService().database?.run(updateQuery!)
                } catch {
                    
                    print("\(error)")
                }
            }
            
            
            if shouldRefreshWhenFinshed {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: YKNotificationConversationListDataSourceUpdated), object: nil)
                
            }
        }
    }
    
    
    func updateConversationAsReadWithLastMessage(lastMessage:AVIMMessage?) {
        
        if currentConversation == nil {
            return
        }
        
        self.insertRecentConversation(conversation: currentConversation!, shouldRefreshWhenFinished: false)
        self.updateUnreadCountToZeroWithConversationId(conversationId: (currentConversation?.conversationId)!, shouldRefreshWhenFinished: false)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: YKNotificationUnreadsUpdated), object: nil
        )
    }
    
    func updateUnreadCountToZeroWithConversationId(conversationId:String,shouldRefreshWhenFinished:Bool) {
        
        let conversation = recentConversationDic[conversationId]
        conversation?.yk_unReadCount = 0
        
        let updateQuery = conversationTable?.filter((Expression<String>("id") == conversationId)).update((Expression<Int>("unReadCount") <- 0))
        do {
            try YKConversationService.defaultService().database?.run(updateQuery!)
        } catch {
            print("\(error)")
        }
        
        if shouldRefreshWhenFinished {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YKNotificationConversationListDataSourceUpdated), object: nil)
        }
    }
    
    
    //MARK: - ****** Insert ******
    func insertRecentConversation(conversation:AVIMConversation,shouldRefreshWhenFinished:Bool) {
        
        self.insertRecentConversations(conversations: [conversation], shouldRefreshWhenFinished: shouldRefreshWhenFinished)
    }
    
    func insertRecentConversations(conversations:Array<AVIMConversation>,shouldRefreshWhenFinished:Bool) {
        
        for (_,conversation) in conversations.enumerated() {
            if conversation.createAt != nil {
                self.recentConversationDic.updateValue(conversation, forKey: conversation.conversationId!)
                
                self.writeConversationToDB(conversation: conversation)
                
            }
        }
        
        if shouldRefreshWhenFinished {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YKNotificationConversationListDataSourceUpdated), object: nil)
        }
    }
    
    func increaseUnreadCountWithConversationId(conversationId:String, shouldRefreshWhenFinished:Bool) {
        self.increaseUnReadCount(increaseUnreadCount: 1, with: conversationId, shouldRefreshWhenFinished: shouldRefreshWhenFinished)
    }
    
    
    func increaseUnReadCount(increaseUnreadCount:Int,with conversationId:String,shouldRefreshWhenFinished:Bool) {
        let conversation = recentConversationDic[conversationId]
        conversation?.yk_unReadCount += increaseUnreadCount
        
        let updateQuery = conversationTable?.filter((Expression<String>("id") == conversationId)).update((Expression<Int>("unReadCount")+=increaseUnreadCount))
        do {
            try YKConversationService.defaultService().database?.run(updateQuery!)
        } catch {
            print("\(error)")
        }
        
        if shouldRefreshWhenFinished {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: YKNotificationConversationListDataSourceUpdated), object: nil)
        }
    }
    
    
    func writeConversationToDB(conversation:AVIMConversation) {
        
        var unreadCount = 0
        
        if let cacheConversaton = recentConversationDic[conversation.conversationId!] {
            unreadCount = cacheConversaton.yk_unReadCount + Int(conversation.unreadMessagesCount)
        }
        
        let insert = conversationTable?.insert(or: .replace, Expression("id") <- conversation.conversationId,Expression("data") <- conversation.converToData(),Expression("unReadCount") <- unreadCount,Expression("draft") <- "",Expression("mentioned") <- false)
        do {
            try YKConversationService.defaultService().database?.run(insert!)
        } catch {
            print("\(error)")
        }
    }
}
