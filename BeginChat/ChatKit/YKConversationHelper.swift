//
//  YKConversationHelper.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/27.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import UIKit
import AVOSCloudIM
let YKCellIdentifyGroup = "YKCellIdentifierGroup"
let YKCellIdentifySingle = "YKCellIdentifySingle"

let YKCellIdentifyOwnerSelf = "YKCellIdentifyOwnerSelf"
let YKCellIdentifyOwnerOhter = "YKCellIdentifyOwnerOhter"
let YKCellIdentifyOwnerSystem = "YKCellIdentifyOwnerSystem"


var YKChatMessageCellMediaTypeDict:Dictionary<Int, Any>?



class YKMessageCellIdentifyFactory {
    
   class func registerChatMessageCellClassForTableView(tableView:UITableView) {
        
        for (key,value) in YKChatMessageCellMediaTypeDict! {
            let cellClass = value as AnyObject
            
            let className = NSStringFromClass(cellClass as! AnyClass)
            
            if key != -7 {
                
                tableView.register((cellClass as! AnyClass), forCellReuseIdentifier: String.init(format: "%@_%@_%@", className,YKCellIdentifyOwnerSelf,YKCellIdentifySingle))
                tableView.register((cellClass as! AnyClass), forCellReuseIdentifier: String.init(format: "%@_%@_%@", className,YKCellIdentifyOwnerOhter,YKCellIdentifySingle))
                tableView.register((cellClass as! AnyClass), forCellReuseIdentifier: String.init(format: "%@_%@_%@", className,YKCellIdentifyOwnerSelf,YKCellIdentifyGroup))
                tableView.register((cellClass as! AnyClass), forCellReuseIdentifier: String.init(format: "%@_%@_%@", className,YKCellIdentifyOwnerSelf,YKCellIdentifyGroup))
            }else{
                
                tableView.register((cellClass as! AnyClass), forCellReuseIdentifier: String.init(format: "%@_%@_%@", className,YKCellIdentifyOwnerSystem,YKCellIdentifyGroup))
                tableView.register((cellClass as! AnyClass), forCellReuseIdentifier: String.init(format: "%@_%@_%@", className,YKCellIdentifyOwnerSystem,YKCellIdentifySingle))
            }
        }
    }
    
    class func cellIdentifyForMessage(message:YKMessage,conversataionType:YKConversationType) -> String? {
        
        var groupKey:String?
        
        switch conversataionType {
        case .Group:
            groupKey = YKCellIdentifyGroup
        case .Single:
            groupKey = YKCellIdentifySingle
        }
        
        var ownerTypeKey: String?

        let ownerType:YKMessageOwnerType = message.ownerType
        
        switch ownerType {
        case .ByOther:
            ownerTypeKey = YKCellIdentifyOwnerOhter
        case .BySelf:
            ownerTypeKey = YKCellIdentifyOwnerSelf
        case .BySystem:
            ownerTypeKey = YKCellIdentifyOwnerSystem
        default:
            ownerTypeKey = YKCellIdentifyOwnerSystem
        }
        
        let mediaType:Int = Int(message.mediaType!)
        
        let cellClass = YKChatMessageCellMediaTypeDict?[mediaType]
        
        let className = NSStringFromClass(cellClass as! AnyClass)
        
        return String.init(format: "%@_%@_%@", className,ownerTypeKey!,groupKey!)
    }
    
    
   class func registerChatMessageCellMediaTypeDict(cellClassNames:Array<Dictionary<Int, String>>)  {
        for (_,value) in cellClassNames.enumerated() {
            
            let valDic:Dictionary<Int, String> = value 
            
            if YKChatMessageCellMediaTypeDict == nil {
                YKChatMessageCellMediaTypeDict = Dictionary.init()
            }
            
            for (dicKey,dicValue) in valDic {
                
                let className:String = dicValue 

                var cellClass:AnyClass?
                
                cellClass = NSObject.swiftClassFromString(className: className)

                YKChatMessageCellMediaTypeDict?[dicKey] = cellClass
            }
        }
    }
}


class YKMessageCellBubbleImageFactory {
    
   class func bubbleImageViewWith(owner:YKMessageOwnerType,messageType:AVIMMessageMediaType,isHighlighted:Bool) -> UIImage {
        
        var imagePath = "message_"
        
        switch messageType {
        case kAVIMMessageMediaTypeImage , kAVIMMessageMediaTypeLocation:
            imagePath.append("hollow_")
        default:
            break
        }
        
        switch owner {
        case .ByOther:
            imagePath.append("receiver_")
        case .BySelf:
            imagePath.append("sender_")
        default:
            break
        }
        
        imagePath.append("background_")
        
        if isHighlighted {
            imagePath.append("highlight")
        }else {
            imagePath.append("normal")
        }
        
        let image = UIImage.init(named: imagePath)
        
        return (image?.resizableImage(withCapInsets: UIEdgeInsetsMake(30, 16, 16, 24), resizingMode: UIImageResizingMode.stretch))!
    }
}
