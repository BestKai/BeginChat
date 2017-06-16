//
//  NSObject+YKExtension.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/28.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation

extension NSObject {
    class func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
            let classStringName = appName + "." + className
            // return the class!
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}
