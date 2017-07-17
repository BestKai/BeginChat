//
//  YKChatKit.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/8.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM
class YKChatKit: NSObject {
    
    var appId:String?
    var appKey:String?
    
    lazy var sessionService: YKSessionService = {
        return YKSessionService.defaultService()
    }()
    
    lazy var conversationService: YKConversationService = {
        return YKConversationService.defaultService()
    }()
    
    
    lazy var clientId: String? = {
        return self.sessionService.clientId
    }()
    
    lazy var client: AVIMClient? = {
        return self.sessionService.client
    }()
    
    
    open class func defaultKit() -> YKChatKit {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let defaultKit = YKChatKit()
            private init(){}
        }
        /** @return Returns the default singleton instance. */
        return Static.defaultKit
    }
    
    //MARK: - ****** Public Methods ******
    
    func setIdAndKey(appId:String, appKey:String) {
        
        AVOSCloud.setApplicationId(appId, clientKey: appKey)
        
        YKChatKit.defaultKit().appId = appId
        YKChatKit.defaultKit().appKey = appKey
    }
    
    
    func creatConversationWithMembers(members:Array<Any>,type:YKConversationType,unique:Bool,callback:@escaping AVIMConversationResultBlock) {
        self.conversationService.createCovnersationWithMembers(members: members as! Array<String>, type: type, unique: unique, callback: callback)
    }
    
    
    func openWithClientId(clientId:String,callback:@escaping YKBooleanResultClosure) {
        self.sessionService.openWithClientId(clientId: clientId, callback: callback)
    }
    
    func openWithClientId(clientId:String, force:Bool, callback:@escaping YKBooleanResultClosure) {
        self.sessionService.openWithClientId(clientId: clientId, force: force, callback: callback)
    }
    
    
    func closeWithCallBack(callback:@escaping YKBooleanResultClosure) {
        self.sessionService.closeWithCallBack(callback: callback)
    }
    
}
//MARK: - ****** BadgeValue ******
extension YKChatKit {
   class func handleBadgeView(controller:UIViewController,totalCount:Int) {
        
        var badgeValue = "\(totalCount)"
        
        if totalCount > 0 {
            if totalCount > 99 {
                badgeValue = YKBadgeValueGreaterThanLimit
            }
            controller.tabBarItem.badgeValue = badgeValue
            UIApplication.shared.applicationIconBadgeNumber = totalCount
        }else{
            controller.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}
