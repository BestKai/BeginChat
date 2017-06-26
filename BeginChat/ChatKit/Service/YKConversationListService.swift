//
//  YKConversationListService.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/20.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM

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
    
    func fetchRelationConversationFromServer(isRefresh:Bool, callback:@escaping AVIMArrayResultBlock) {
        
        let client = YKSessionService.defaultService().client
        
        let conversationQuery = client?.conversationQuery()
        
        conversationQuery?.limit = 1000
        if isRefresh {
            conversationQuery?.cachePolicy = .networkOnly
        }else{
            conversationQuery?.cachePolicy = .cacheThenNetwork
        }
        conversationQuery?.option = .withMessage
     conversationQuery?.findConversations(callback: callback)
    }
    
    
    func fetchConversationById(conversationId:String,closuer:@escaping AVIMConversationResultBlock)  {
        
        let client = YKSessionService.defaultService().client
        
        let conversationQuery = client?.conversationQuery()
        
     conversationQuery?.option = .withMessage
 conversationQuery?.getConversationById(conversationId, callback: closuer)
    }
    
    
    
}
