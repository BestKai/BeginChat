//
//  YKChatConstant.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/12.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import AVOSCloudIM
    


public typealias AVProgressClosure = (NSInteger) -> Void
public typealias YKBooleanResultClosure = (Bool,Error?) -> Void
public typealias YKVoidClosure = () -> Void
public typealias YKErrorClosure = (Error) -> Void

public typealias YKArrayResultBlock = ([Any]?, Error?) -> Void

public typealias YKFetchConversationHandler = (AVIMConversation?,YKConversationViewController?) -> Void

public typealias YKConversationResultClosure = (AVIMConversation?,Error?) -> Void

public let YKOnePageSize = 10


public let YKNotificationMessageReceived = "YKNotificationMessageReceived"
public let YKDidReceiveMessagesUserInfoMessagesKey = "receivedMessages"
public let YKMessageNotificationUserInfoConversationKey = "conversation"



