//
//  YKRegisterViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/24.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloud

class YKRegisterViewController: UIViewController,UITextFieldDelegate {

   private var phoneNumberTextField: UITextField?
   private var sendCodeButton: UIButton?
   private var codeTextField: UITextField?
   private var registerButton: UIButton?
   private var passwordTextField: UITextField?
    
   private var smsTimer: Timer?
   private var originSecond = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "注册账号"
        self.view.backgroundColor = UIColor.white

        self.initSubViews()
        self.registerTextFieldNotification()
    }
    
    func registerTextFieldNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    

    func initSubViews() {
        
        phoneNumberTextField = UITextField.init()
        phoneNumberTextField?.borderStyle = UITextBorderStyle.roundedRect
        phoneNumberTextField?.placeholder = "电话"
        phoneNumberTextField?.keyboardType = UIKeyboardType.phonePad
        self.view.addSubview(phoneNumberTextField!)
        
        sendCodeButton = UIButton.init(type: UIButtonType.system)
        sendCodeButton?.setTitle("发送验证码", for: UIControlState.normal)
        sendCodeButton?.setTitleColor(UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1), for: UIControlState.normal)
        sendCodeButton?.layer.cornerRadius = 5
        sendCodeButton?.layer.masksToBounds = true
        sendCodeButton?.layer.borderColor = UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1).cgColor
        sendCodeButton?.layer.borderWidth = 0.5
        sendCodeButton?.addTarget(self, action: #selector(sendVerifiCode), for: UIControlEvents.touchUpInside)
        sendCodeButton?.ykIsEnable = false
        self.view.addSubview(sendCodeButton!)

        codeTextField = UITextField.init()
        codeTextField?.borderStyle = UITextBorderStyle.roundedRect
        codeTextField?.placeholder = "验证码"
        codeTextField?.keyboardType = UIKeyboardType.numberPad
        self.view.addSubview(codeTextField!)

        
        passwordTextField = UITextField.init()
        passwordTextField?.borderStyle = UITextBorderStyle.roundedRect
        passwordTextField?.placeholder = "密码"
        passwordTextField?.keyboardType = UIKeyboardType.numberPad
        self.view.addSubview(passwordTextField!)

        
        registerButton = UIButton.init(type: UIButtonType.system)
        registerButton?.setTitle("注册", for: UIControlState.normal)
        registerButton?.setTitleColor(UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1), for: UIControlState.normal)
        registerButton?.layer.cornerRadius = 5
        registerButton?.layer.masksToBounds = true
        registerButton?.layer.borderColor = UIColor.init(colorLiteralRed: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1).cgColor
        registerButton?.layer.borderWidth = 0.5
        registerButton?.ykIsEnable = false
        registerButton?.addTarget(self, action: #selector(registerUser), for: UIControlEvents.touchUpInside)
        self.view.addSubview(registerButton!)

        
        phoneNumberTextField?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view).offset(84)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo((sendCodeButton?.snp.left)!).offset(-12)
            make.height.equalTo(40)
        })
        
        sendCodeButton?.snp.makeConstraints({ (make) in
            make.top.equalTo(phoneNumberTextField!.snp.top)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(40)
            make.width.equalTo(100)
        })
        
        codeTextField?.snp.makeConstraints({ (make) in
            make.top.equalTo(phoneNumberTextField!.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(40)
        })
        
        passwordTextField?.snp.makeConstraints({ (make) in
            make.top.equalTo(codeTextField!.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(40)
        })

        
        registerButton?.snp.makeConstraints({ (make) in
            make.top.equalTo(passwordTextField!.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(48)
        })

    }
    //MARK: - 发送验证码
    @objc func sendVerifiCode() {
        
        let phoneNumberStr = phoneNumberTextField?.text
        
        if (phoneNumberStr?.isAvaliablePhoneNumber())! {
            
            self.startcountdownTimer()
            
//            SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneNumberStr, zone: "86", customIdentifier: nil, result: { (error) in
//                if error == nil {
//                    print("验证码发送成功")
//                    self.startcountdownTimer()
//                }else{
//                   self.showErrorMessage(errorMsg: (error?.localizedDescription)!)
//                }
//            })
        }else{
            YKProgressView.showErrorMessage(errorMsg: "手机号非法", view: (self.navigationController?.view)!)
        }
    }
    
    
    func startcountdownTimer() {
        if (smsTimer == nil) {
            smsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDownTime), userInfo: nil, repeats: true)
        }
        originSecond = 30
        smsTimer?.fire()
    }
    
   @objc func countDownTime() {
        originSecond -= 1
        
        if originSecond >= 0 {
            sendCodeButton?.titleLabel?.text = String.init(format: "%d", originSecond)
            sendCodeButton?.setTitle(String.init(format: "%d", originSecond), for: UIControlState.normal)
            sendCodeButton?.ykIsEnable = false
        }else{
            sendCodeButton?.titleLabel?.text = "发送验证码"
            sendCodeButton?.setTitle("发送验证码", for: UIControlState.normal)
            smsTimer?.invalidate()
            sendCodeButton?.ykIsEnable = true
        }
    }
    
    //MARK: - UITextFieldNotification

   @objc func textFieldTextDidChange(notification:NSNotification) {
        let textField = notification.object as! UITextField
        
        if textField == phoneNumberTextField {
            
            sendCodeButton?.ykIsEnable = (phoneNumberTextField?.text?.isAvaliablePhoneNumber())!
        }
        
        registerButton?.ykIsEnable = ((phoneNumberTextField?.text?.isAvaliablePhoneNumber())! && codeTextField?.text?.characters.count == 4 && ((passwordTextField?.text?.characters.count)! >= 6))
    }
    
    @objc func registerUser() {
        let hud = YKProgressView.showIndeterminate(view:(self.navigationController?.view)!)
        
        let phoneNumber = phoneNumberTextField?.text

        weak var weakSelf = self
        
        SMSSDK.commitVerificationCode(codeTextField?.text, phoneNumber: phoneNumber, zone: "86") { (error) in
            if error != nil {
                let user = AVUser.init()
                
                user.mobilePhoneNumber = phoneNumber
                user.password = weakSelf?.passwordTextField?.text
                
                user.username = String.init(format: "yk%@",(phoneNumber?.substring(from: (phoneNumber?.index((phoneNumber?.endIndex)!, offsetBy: -4))!))!)
                user.signUpInBackground { (success, error) in
                    
                    hud.hide(animated: true)
                    if success {
                        YKProgressView.showSuccessWithMsg(view: (self.navigationController?.view)!, successMsg: "注册成功")
                    }else{
                        YKProgressView.showErrorMessage(errorMsg: (error?.localizedDescription)!, view: (self.navigationController?.view)!)
                    }
                }
            }else{
                YKProgressView.showErrorMessage(errorMsg: (error?.localizedDescription)!, view: (self.navigationController?.view)!)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
