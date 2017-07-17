//
//  YKContactsService.swift
//  BeginChat
//
//  Created by bestkai on 2017/7/6.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM
import SQLite

class YKContactsService: NSObject {
    
    public var contactTable:Table?
    
    @discardableResult open class func defaultService() -> YKContactsService {
        struct Static {
            //Singleton instance. Initializing keyboard manger.
            static let defaultService = YKContactsService()
            
            private init(){}
        }
        /** @return Returns the default singleton instance. */
        return Static.defaultService
    }
    
    override init() {
        super.init()
        
        self.contactTable = Table("Contact")
    }
    
    
    func fetchContacts(closure:@escaping YKArrayResultBlock) {
        
        self.fetchContactsFromLocal { (objects, error) in
            closure(objects, error)
            self.fetchContactsFromServer(closure: closure)
        }
    }
    
    func fetchContactsFromServer(closure:@escaping YKArrayResultBlock) {
        let query = AVQuery.init(className: "_User")
        
        query.whereKey("objectId", notEqualTo: (AVUser.current()?.objectId)!)
        
        query.findObjectsInBackground { (objects, error) in
            closure(self.getCustomUsersWithAVUsers(users: objects),error)
        }
    }
    
    func fetchContactsFromLocal(closure:@escaping YKArrayResultBlock) {
        
        let database = YKConversationService.defaultService().database
        
        var tempDatas = [YKUser]()
        
         do {
            for user in try database!.prepare(contactTable!) {
                tempDatas.append(self.getUserWithResult(result: user))
            }
        } catch {
            print("Contact查询出错")
        }
        closure(tempDatas,nil)
    }
    
    
   private func getCustomUsersWithAVUsers(users:Array<Any>?) -> Array<YKUser> {
        
        var dataSources = Array<YKUser>()
        
        for (_,avuser) in (users?.enumerated())! {
            
            let user = YKUser.init(user: avuser as? AVUser)
            
            dataSources.append(user)
            
            self.writeUserToDatabase(user: user)
        }
        return dataSources
    }
    
    func writeUserToDatabase(user:YKUser) {
        
        let insert = contactTable?.insert(or:.replace, Expression("nickName") <- user.name, Expression("id") <- user.userId, Expression("avatar") <- user.avatarURL?.absoluteString)
        
        do {
            try YKConversationService.defaultService().database?.run(insert!)
        } catch {
            print("插入数据错误")
        }
    }
    
    
    //MARK: - ****** 从数据库查找用户 ******
    func getLocalUserWithUserId(userId:String) -> YKUser? {
        let users = self.getLocalUsersWithUserIds(userIds: [userId])
        
        if users.isEmpty {
            return nil
        }
        return users[0]
    }
    
    
    func getLocalUsersWithUserIds(userIds:Array<String>) -> Array<YKUser> {
        
        let filterQuery = contactTable?.filter(userIds.contains(Expression<String>("id")))
        var users = Array<YKUser>()

        do {
            for user in (try YKConversationService.defaultService().database?.prepare(filterQuery!))! {
                
                users.append(self.getUserWithResult(result: user))
            }
        } catch {
            print("\(error)")
        }
        return users
    }
    
    func getUserWithResult(result:Row) -> YKUser {
        
        let ykuser:YKUser = YKUser.init()
        ykuser.userId = result.get(Expression("id"))
        ykuser.name = result.get(Expression("nickName"))
        ykuser.avatarURL = URL.init(string: result.get(Expression("avatar")))
        return ykuser
    }
}
