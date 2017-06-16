//
//  Dictionary+YKExtension.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/2.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
extension Dictionary {
    
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
