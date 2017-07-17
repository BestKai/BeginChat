//
//  ViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/21.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import SnapKit
import AVOSCloud

class ViewController: UIViewController,UITextFieldDelegate {

    var phoneTextField: UITextField?
    var passwordTextField: UITextField?
    var loginButton: UIButton?
    var signUpButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let infoDic = Bundle.main.infoDictionary
        self.title = infoDic?["CFBundleDisplayName"] as? String
        self.initSubViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)

        
        if (AVUser.current() != nil) {
            
            let mainTabbarVC = YKMainTabViewController.init()
            
            mainTabbarVC.modalTransitionStyle = .crossDissolve
            self.present(mainTabbarVC, animated: true, completion: {
            })
        }
    }
    
    func initSubViews() {
        
        let iconImage = UIImageView.init(image: UIImage.init(named: "app_icon_200"))
        iconImage.layer.cornerRadius = 5
        iconImage.layer.masksToBounds = true
        self.view.addSubview(iconImage)
        
        iconImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).inset(100)
            make.centerX.equalTo(self.view)
            make.size.equalTo(80)
        }
        
        phoneTextField = UITextField.init()
        phoneTextField?.borderStyle = UITextBorderStyle.roundedRect
        phoneTextField?.placeholder = "电话"
        self.view.addSubview(phoneTextField!)
        
        passwordTextField = UITextField.init()
        passwordTextField?.placeholder = "密码"
        passwordTextField?.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(passwordTextField!)
        
        
        loginButton = UIButton.init(type: UIButtonType.system)
        loginButton?.setTitle("登录", for: UIControlState.normal)
        loginButton?.setTitleColor(UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1), for: UIControlState.normal)
        loginButton?.layer.cornerRadius = 5
        loginButton?.layer.masksToBounds = true
        loginButton?.layer.borderColor = UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1).cgColor
        loginButton?.layer.borderWidth = 0.5
        loginButton?.addTarget(self, action:#selector(loginBtTapped), for: UIControlEvents.touchUpInside)
        loginButton?.ykIsEnable = false
        self.view.addSubview(loginButton!)
        
        
        signUpButton = UIButton.init(type: UIButtonType.system)
        signUpButton?.setTitle("注册账号", for: UIControlState.normal)
        signUpButton?.setTitleColor(UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1), for: UIControlState.normal)
        signUpButton?.layer.cornerRadius = 5
        signUpButton?.layer.masksToBounds = true
        signUpButton?.layer.borderColor = UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1).cgColor
        signUpButton?.layer.borderWidth = 0.5
        signUpButton?.addTarget(self, action:#selector(goToRegisterViewController) , for: UIControlEvents.touchUpInside)
        self.view.addSubview(signUpButton!)

        
        phoneTextField?.snp.makeConstraints({ (make) in
            make.top.equalTo(iconImage.snp.bottom).offset(40)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(40)
        })
        
        passwordTextField?.snp.makeConstraints({ (make) in
            make.top.equalTo(phoneTextField!.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(40)
        })

        loginButton?.snp.makeConstraints({ (make) in
            make.top.equalTo(passwordTextField!.snp.bottom).offset(40)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(48)
        })
 
        signUpButton?.snp.makeConstraints({ (make) in
            make.top.equalTo(loginButton!.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(48)
        })
        
    }
    
    
    @objc func goToRegisterViewController() {
        
        let registerVC = YKRegisterViewController.init()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
   @objc  func loginBtTapped() {
        
        let hud = YKProgressView.showIndeterminate(view: (self.navigationController?.view)!)
        
        AVUser.logInWithMobilePhoneNumber(inBackground: (phoneTextField?.text)!, password: (passwordTextField?.text)!) { (user, error) in
            hud.hide(animated: true)
            
            if error == nil {
                
                YKProgressView.showSuccessWithMsg(view: (self.navigationController?.view)!, successMsg: "登录成功")
                
                self.goToMainTabbarViewController()
            }else{
                YKProgressView.showErrorMessage(errorMsg: (error?.localizedDescription)!, view: (self.navigationController?.view)!)
            }
        }
    }
    

    func goToMainTabbarViewController() {
        
        let mainTabbarVC = YKMainTabViewController.init()
        self.navigationController?.present(mainTabbarVC, animated: true, completion: nil)
    }
    
    //MARK: - ****** UITextFieldDelegate ******
    
    @objc func textFieldTextDidChange(notification:NSNotification) {
        
        loginButton?.ykIsEnable = ((phoneTextField?.text?.isAvaliablePhoneNumber())! &&  ((passwordTextField?.text?.characters.count)! >= 6))
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

