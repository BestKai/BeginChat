//
//  UIButton+YKExtension.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import UIKit
public extension UIButton {
    
    var ykIsEnable: Bool {
        set (newValue){
            self.alpha = newValue ? 1 : 0.4
            self.isEnabled = newValue
        }
        get {
            return self.isEnabled
        }
    }
}
