//
//  NSString+YKExtension.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/24.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import UIKit

public extension NSString {
    func isAvaliablePhoneNumber() -> Bool {
        
        let PNStr = "^(1)\\d{10}$"
        
        let PNPred = NSPredicate(format: "SELF MATCHES %@",PNStr)
        
        return PNPred.evaluate(with:self)
    }
    
    
    func height(fontSize:Float,maxWidth:Float) -> Double {
        
        let textSize = self.boundingRect(with: CGSize.init(width: CGFloat(maxWidth), height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize:CGFloat(fontSize) ) ], context: nil).size
        
        return Double(textSize.height)
    }
    
}
