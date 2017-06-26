//
//  YKConversationViewController.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/26.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit
import AVOSCloudIM


//类必须为 public  否则 YKFetchConversationHandler  报错 its underlying type uses an internal type
public class YKConversationViewController: YKBaseTableViewController, YKChatBarDelegate,YKConversationViewModelDelegate {

    var chatBar: YKChatBar?
    
    var conversationId : String?//多人聊天
    var peerId : String?//单人聊天
    var loadingMoreMessage:Bool = false
    var shouldLoadMoreMessages:Bool = true
    
    var refreshConversationClosure: ((AVIMConversation) -> Void)?
    
    
    var fetchConversationHandler: YKFetchConversationHandler?
    
    var conversation:AVIMConversation?
    
    lazy var chatViewModel : YKConversationViewModel = {
        
        let chatViewModel: YKConversationViewModel = YKConversationViewModel.init(parentViewController: self)
        chatViewModel.delegate = self
        return chatViewModel
    }()
    
    
    
    init(conversationId : String?, peerId: String?) {
        super.init()
        self.conversationId = conversationId
        self.peerId = peerId
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.chatViewModel.setDefaultBackgroundImge()
    }

    override func setUpUI() {
        super.setUpUI()
        
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView?.backgroundColor = UIColor.init(colorLiteralRed: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        self.allowScrollToBottom = true

        
        
        chatBar = YKChatBar.init(frame: CGRect.zero)
        chatBar?.delegate = self
        self.view.addSubview(chatBar!)
        self.tableView?.snp.makeConstraints({ (make) in
            
            make.left.right.top.equalTo(0)
            make.bottom.equalTo((chatBar?.snp.top)!).offset(0)
        })
        
        chatBar?.snp.makeConstraints({ (make) in
            
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(YKChatBarMinHeight)
        })
        
        YKMessageCellIdentifyFactory.registerChatMessageCellMediaTypeDict(cellClassNames: [[-1:"YKChatTextMessageCell"],[-7:"YKChatSystemMessageCell"]])
        
        
        YKMessageCellIdentifyFactory.registerChatMessageCellClassForTableView(tableView: self.tableView!)
        self.setUpData()
    }
    
    private func setUpData() {
        
        self.setUpConversation()
        
        let clientStatusOpened = YKSessionService.defaultService().client?.status == AVIMClientStatus.opened
        
        if !clientStatusOpened {
            print("未开启")
        }
    }
    
    private func setUpConversation() {
        repeat {
            
            if peerId != nil {
                YKConversationService.defaultService().fetchConversationWithPeerId(peerId: peerId!, callback: { (conversatioin, error) in
                    self.refreshConversation(conversation: conversatioin!, isJoined: true)
                })
                break
            }
            
            if self.conversationId != nil {
                YKConversationService.defaultService().fetchConversationWithConversationId(conversationId: self.conversationId!, callBack: { (conversation, error) in
                    
                    if error != nil {
                        self.refreshConversation(aConversation: conversation, isJoined: false, error: error)
                    }else{
                        
                        let currentClientId = YKSessionService.defaultService().clientId
                        
                        if conversation?.members?.count == 0 && (!(conversation?.transient)!) {
                            self.refreshConversation(conversation:conversation!, isJoined:true)
                            return
                        }
                        
                        let tempMembers:[String] = (conversation?.members)! as! [String]
                        
                        let containsCurrentClientId = tempMembers.contains(currentClientId!)
                        
                        if containsCurrentClientId {
                            self.refreshConversation(conversation:conversation!, isJoined:true)
                            
                            return
                        }
                    }
                })
            }
        }while false;
    }
    
    
    
    //MARK: - UITableViewDataSources && UITableViewDelegate
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.dataSources[indexPath.row] as! YKMessage
        
        let cellIdentify = YKMessageCellIdentifyFactory.cellIdentifyForMessage(message: message, conversataionType: YKConversationType.Single)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify!, for: indexPath) as! YKChatMessageTableViewCell
        
        cell.configureCellWithData(message: message)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.dataSources[indexPath.row] as! YKMessage
        return message.cellHeight
    }
    
    
    //MARK: - YKChatBarDelegate
    func chatBarFrameDidChangeShouldScrollToBottom(chatbar: YKChatBar, shouldScrollToBottom: Bool) {
        
        UIView.animate(withDuration: YKAnimateDuration) { 
            
            self.tableView?.superview?.layoutIfNeeded()

            self.scrollToBottomAnimated(animated: false)
        }
    }
    
    func chatBarSendMessage(chatbar: YKChatBar, message: String) {
        
        self.sendTextMessage(message)
    }
    
    
    
    //MARK: - ****** UIScrollViewDelegate ******
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let menu = UIMenuController.shared
        if menu.isMenuVisible {
            menu.setMenuVisible(false, animated: true)
        }
        self.chatBar?.endInputing()
        
    }
    
    
    
    //MARK: - ****** YKConversationViewModelDelegate ******
    
    func messageReadStateChanged(message: Any, readStatus: YKMessageReadStatus, progress: Double) {
        
    }
    
    func messageSendStateChanged(message: Any, sendStatus: YKMessageSendStatus, progress: Double) {
        
        let _: IndexPath = IndexPath.init(row: self.dataSources.count - 1, section: 0)
        
        DispatchQueue.main.async {
//            (self.tableView?.insertRows(at: [indexPath], with: .none))!
            
            self.tableView?.reloadData()
            
            self.scrollToBottomAnimated(animated: true)
            
            if self.refreshConversationClosure != nil {
                self.refreshConversationClosure!(self.conversation!)
            }
        }
    }
    
    
    func reloadAfterReceiveMessage() {
        self.tableView?.reloadData()
        self.scrollToBottomAnimated(animated: true)
        
        if self.refreshConversationClosure != nil {
            self.refreshConversationClosure!(self.conversation!)
        }
    }
    
    
    
    //MARK: - ****** PublicMethods ******
    
    func getConversationIfExists() -> AVIMConversation? {
        
        if self.conversation != nil {
            return conversation
        }
        return nil
    }
    
    func sendTextMessage(_ message:String) {
        
        let textMessage = YKMessage.init(text: message, sender: nil, timestamp: YK_CURRENT_TIMESTAMP, serverMessageId: nil, chatType: .Single)
        
        chatViewModel.sendMessage(message: textMessage)
    }
    
    
    
    //MARK: - ****** Private Methods ******
    
    private func refreshConversation(conversation:AVIMConversation, isJoined:Bool){
        self.refreshConversation(aConversation: conversation, isJoined: isJoined, error: nil)
    }
    
    
    private func refreshConversation(aConversation:AVIMConversation?, isJoined:Bool, error:Error?) {
        if error != nil {
            
            
        }
        
        var conversation:AVIMConversation?
        
        if isJoined && error==nil {
            conversation = aConversation
        }
        
        self.conversation = conversation
        self.saveCurrentConversationInfoIfExists()
        
        self.callbackCurrentConversatioinEventNotExists(conversation: conversation!) { (succeeded, error) in
            self.handleLoadHistoryMessagesHandlerIfIsJoined(isJoined: isJoined)
        }
    }
    
    func callbackCurrentConversatioinEventNotExists(conversation:AVIMConversation, callback:YKBooleanResultClosure?) {
        
        if conversation.createAt != nil {
            if conversation.imClient == nil {
                conversation.setValue(YKSessionService.defaultService().client, forKey: "imClient")
            }
            
            self.conversationId = conversation.conversationId
            let members = conversation.members
            
            //系统对话
            if members?.count == 0 {
                self.title = "系统消息"
                if callback != nil {
                    callback!(true,nil)
                }
                return
            }
            
            if self.peerId == nil && members?.count == 2 {
                peerId = conversation.yk_peerId
            }
            
            self.fetchConversationHandler(conversation: conversation)
            
            if callback != nil {
                callback!(true,nil)
            }
        }else{
            self.fetchConversationHandler(conversation: conversation)
            let error = NSError.init(domain: String(describing: self), code: 0, userInfo: ["code":0,NSLocalizedDescriptionKey:"error reason"])
            if callback != nil {
                callback!(false,error)
            }
        }
        
    }
    
     private func getConversationIdIfExists(conversation:AVIMConversation?) -> String? {
        var conversationId: String?
        
        if self.conversationId != nil {
            conversationId = self.conversationId
        }
        
        if self.conversation != nil {
            conversationId = self.conversation?.conversationId
        }
        
        if conversation != nil {
            conversationId = conversation!.conversationId
        }
        return conversationId
    }
    
    func saveCurrentConversationInfoIfExists() {
        
        let conversationId = self.getConversationIdIfExists(conversation: nil)
        
        if conversationId != nil {
            YKConversationService.defaultService().currentConversationId = conversationId
        }
        
        if self.conversation != nil {
            YKConversationService.defaultService().conversation = self.conversation
        }
    }
    
    func fetchConversationHandler(conversation:AVIMConversation) {
        
        var fetchConversationhandler: YKFetchConversationHandler?
        repeat {
            if self.fetchConversationHandler != nil {
                fetchConversationhandler = self.fetchConversationHandler
                break
            }
            
            let generalFetchConversationHandler = YKConversationService.defaultService().fetchConversationHandler
            
            if generalFetchConversationHandler != nil {
                fetchConversationhandler = generalFetchConversationHandler
            }
        } while false
        
        if fetchConversationhandler != nil {
            fetchConversationhandler!(conversation,self)
        }
    }
    
    func handleLoadHistoryMessagesHandlerIfIsJoined(isJoined:Bool) {
        
        if isJoined {
            //在会话中
            self.chatViewModel.loadMessagesFirstTimeWithCallback(callback: { (succeeded, error) in
                self.tableView?.reloadData()
                self.scrollToBottomAnimated(animated: true)
            })
        }else{
//            chatViewModel.
            
        }
    }
    
    private func notJoinedHandler(conversation:AVIMConversation?,error:Error){
        
    }
    
    override public func didReceiveMemoryWarning() {
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
