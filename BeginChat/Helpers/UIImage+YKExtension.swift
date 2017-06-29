//
//  UIImage+YKExtension.swift
//  BeginChat
//
//  Created by bestkai on 2017/6/28.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func imageByResizeToSize(size:CGSize) -> UIImage? {
        
        if size.width<=0 || size.height<=0 {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
