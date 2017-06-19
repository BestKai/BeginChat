//
//  YKProgressView.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/25.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import Foundation
import MBProgressHUD

class YKProgressView {
    
    
    @discardableResult  class func showWithMessage(message:String) -> MBProgressHUD {
        
        let view = UIApplication.shared.keyWindow
        
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        
        return hud
    }
    
    class func hiddenProgressView(view:UIView?) {
        
        var tempView = view
        if tempView == nil {
            tempView = UIApplication.shared.keyWindow
        }
        MBProgressHUD.hide(for: tempView!, animated: true)
    }
    
    
    class func showErrorMessage(errorMsg: String,view: UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = errorMsg
        hud.hide(animated: true, afterDelay: 1)
    }

    
   class func showIndeterminate(view: UIView) -> MBProgressHUD {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.isUserInteractionEnabled = false
        return hud
    }
    
    class func showSuccessWithMsg(view:UIView,successMsg:String) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.customView
        hud.customView = UIImageView.init(image: UIImage.init(named: "Checkmark"))
        hud.isSquare = true
        hud.label.text = successMsg
        hud.hide(animated: true, afterDelay: 1)
    }
    
}
