//
//  AVIMConversation+YKExtension.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/9.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM

private var CONVErSATION_UNREADCOUNT_PROPERTY = 0


extension AVIMConversation {
    
    var yk_peerId: String {
        get {
            
            let members = self.members
            
            if members?.count == 0 {
                let exceptionStr = "invalid conversation"
                let e = NSException.init(name: NSExceptionName(rawValue: exceptionStr), reason: exceptionStr, userInfo: nil)
                e.raise()
            }
            
            if members?.count == 1 {
                return members?.first as! String
            }
            
            var peerId: String?
            
            let tempMembers:[String] = members as! [String]
            
            if tempMembers.first == YKSessionService.defaultService().clientId {
                peerId = tempMembers[1]
            }else{
                peerId = tempMembers[0]
            }
            return peerId!
        }
    }
    
    var yk_unReadCount:Int {
        get {
            guard let count = objc_getAssociatedObject(self, &CONVErSATION_UNREADCOUNT_PROPERTY) as? Int else { return 0 }
            return count
        }
        set {
            objc_setAssociatedObject(self, &CONVErSATION_UNREADCOUNT_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func converToData() -> Data {
        
        let keydConversation = self.keyedConversation()
        let data = NSKeyedArchiver.archivedData(withRootObject: keydConversation)
        return data
    }
    
    class func getConversatioinWithData(data:Data) -> AVIMConversation? {
        let keydConversatioin = NSKeyedUnarchiver.unarchiveObject(with: data)
        let conversation = YKConversationService.defaultService().client?.conversation(with: keydConversatioin as! AVIMKeyedConversation)
        
        return conversation
    }
    
    
}
