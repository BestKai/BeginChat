//
//  UIColor+YKExtension.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/21.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func colorWithRGBValue(rgbValue:UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
