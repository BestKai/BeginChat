//
//  YKChatBarHelper.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/1.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import UIKit
@objc protocol YKChatBarDelegate {
    
   @objc optional func chatBarSendMessage(chatbar:YKChatBar, message:String) -> ()
    
   @objc optional func chatBarFrameDidChangeShouldScrollToBottom(chatbar:YKChatBar, shouldScrollToBottom:Bool) -> ()
    
    @objc optional func chatBarSendImageMessage(imageMessage:UIImage?)
}
