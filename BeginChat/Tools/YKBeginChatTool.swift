//
//  YKBeginChatTool.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/17.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import UIKit

class YKBeginChatTool: NSObject {
    
    open class func defaultTool() -> YKBeginChatTool {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let defaultTool = YKBeginChatTool()
            private init(){}
        }
        /** @return Returns the default singleton instance. */
        return Static.defaultTool
    }
    
   class func invokeThisMethodBeforeLogout(success:YKVoidClosure?,failed:YKErrorClosure?) {
    
        YKChatKit.defaultKit().closeWithCallBack { (succeeded, error) in
            
            if succeeded {
                if success != nil {
                    success!()
                }
            }else{
                if failed != nil {
                    failed!(error!)
                }
            }
        }
    }
    
    
    
    
    //MARK: - ****** Class Methods ******
    class func logOutFromViewController(viewController:UIViewController) {
        
        YKProgressView.showWithMessage(message: "退出登录")
        YKBeginChatTool.invokeThisMethodBeforeLogout(success: {
            YKProgressView.hiddenProgressView(view: nil)
            
            let tabbarVC = viewController.navigationController?.tabBarController
            
            tabbarVC?.dismiss(animated: true, completion: nil)
            
        }) { (error) in
            YKProgressView.hiddenProgressView(view: nil)
        }
    }
    
    
    
}
