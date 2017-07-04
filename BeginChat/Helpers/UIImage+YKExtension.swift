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
    
    func yk_imageBy(bundleName:String?,imageName:String) -> UIImage? {
        
        if bundleName == nil {
            return UIImage.init(named: imageName)
        }
        
        let mainBundle = Bundle.main
        
        let bundlePath = mainBundle.path(forResource: bundleName, ofType: "bundle")
        
        let imgeTypes = ["png","jpeg","jpg","gif","webp","apng"]
        
        let scales = Bundle.preferredScales()
        
        if bundlePath != nil {
            
            var imagePath:String?
            
            for (_,scale) in scales.enumerated() {
                
                for (_,type) in imgeTypes.enumerated() {
                    imagePath = Bundle.init(path: bundlePath!)?.path(forResource: imageName.appending(String.init(format: "@%dx", scale)), ofType: type)
                    if imagePath != nil {
                        break
                    }
                }
            }
            
            if imagePath != nil {
                return UIImage.init(contentsOfFile: imagePath!)
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
}


extension Bundle {
    
    class func preferredScales() -> Array<UInt> {
        
        let screenScale = UIScreen.main.scale
        var scales = Array<UInt>()
        
        if screenScale <= 1 {
            scales = [1,2,3]
        }else if screenScale <= 2 {
            scales = [2,3,1]
        }else{
            scales = [3,2,1]
        }
        return scales
    }
}
