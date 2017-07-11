//
//  YKSoundManager.swift
//  BeginChat
//
//  Created by bestkai on 2017/7/11.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AudioToolbox

class YKSoundManager: NSObject {
    
    var needVibrateWhenNotChatting:Bool? {
        set{
            UserDefaults.standard.set(newValue, forKey: "needVibrateWhenNotChatting")
        }
        get{
           return UserDefaults.standard.bool(forKey: "needVibrateWhenNotChatting")
        }
    }
    var needPlaySoundWhenNotChatting:Bool? {
        set{
            UserDefaults.standard.set(newValue, forKey: "needPlaySoundWhenNotChatting")
        }
        get{
           return UserDefaults.standard.bool(forKey: "needPlaySoundWhenNotChatting")
        }
    }
    var needPlaySoundWhenChatting:Bool? {
        set{
            UserDefaults.standard.set(newValue, forKey: "needPlaySoundWhenNotChatting")
        }
        get{
          return UserDefaults.standard.bool(forKey: "needPlaySoundWhenNotChatting")
        }
    }
    
    
    private var loudReceiveSound:SystemSoundID = 0
    private var sendSound:SystemSoundID = 0
    private var receiveSound:SystemSoundID = 0
    
    //MARK: - ****** Swift Singleton ******
    @discardableResult open class func manager() -> YKSoundManager {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let defaultManager = YKSoundManager()
            private init(){}
        }
        /** @return Returns the default singleton instance. */
        return Static.defaultManager
    }
    
    override init() {
        super.init()
        
        self.createSoundWith(url: self.soundURLWithName(soundName: "loudReceive"), soundId: &loudReceiveSound)
        self.createSoundWith(url: self.soundURLWithName(soundName: "send    "), soundId: &sendSound)
        self.createSoundWith(url: self.soundURLWithName(soundName: "receive"), soundId: &receiveSound)
        
        if !UserDefaults.standard.bool(forKey: "haveSetDefaultSound") {
            UserDefaults.standard.set(true, forKey: "haveSetDefaultSound")
            UserDefaults.standard.set(true, forKey: "needVibrateWhenNotChatting")
            UserDefaults.standard.set(true, forKey: "needPlaySoundWhenNotChatting")
            UserDefaults.standard.set(true, forKey: "needPlaySoundWhenNotChatting")
        }
    }
    
    private func soundURLWithName(soundName:String) -> URL?{
        let url = Bundle.main.url(forResource: soundName, withExtension: "caf")
        
        return url
    }
    
    private func createSoundWith(url:URL?, soundId:inout SystemSoundID){
        if url != nil {
            let errorCode = AudioServicesCreateSystemSoundID(url! as CFURL, &soundId)
            if errorCode != 0 {
                print("create sound failed")
            }
        }else{
            print("sound path is nil create sound failed")
        }
    }
    
    /// 播放发送消息音效
    func playSendSoundIfNeed() {
        if needPlaySoundWhenChatting == true {
            AudioServicesPlaySystemSound(sendSound)
        }
    }
    
    /// 播放接受消息音效
    func playReceiveSoundIfNeed() {
        if needPlaySoundWhenChatting == true {
            AudioServicesPlaySystemSound(receiveSound)
        }
    }
    
    /// 播放较响亮的接受消息音效
    func playLoudReceiveSoundIfNeed() {
        if needPlaySoundWhenNotChatting == true {
            AudioServicesPlaySystemSound(loudReceiveSound)
        }
    }
    
    /// 震动
    func vibrateIfNeed() {
        if needVibrateWhenNotChatting == true {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
}
