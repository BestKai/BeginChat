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
    
    open class func defaultService() -> YKSessionService {
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
        
    }
    
    
    
    func closeWithCallBack(callback:@escaping YKBooleanResultClosure) {
        client?.close(callback: { (succeeded, error) in
            if succeeded {
                callback(succeeded, error)
                self.resetService()
            }
        })
    }
    
    func resetService() {
        
    }
    
}
