//
//  AVIMConversation+YKExtension.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/9.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM
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
    
}
