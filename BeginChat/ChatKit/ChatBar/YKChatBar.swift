//
//  YKChatBar.swift
//  BeginChat
//
//  Created by bestkai on 2017/4/26.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit

// functionView 类型
enum YKFunctionViewShowType: Int {
    case showNothing = 0
    case showVoice = 1
    case showFace = 2
    case showMore = 3
    case showKeyboard = 4
}

let YKChatBarTextFontSize = 15.0

let YKChatBarBottomMargin = 8.0
let YKChatBarLeftRightMargin = 4.0
let YKChatBarButtonTopMargin = 5.5


let YKChatBarTextViewMinHeight = 30.0
let YKChatBarTextViewMaxHeight = 102.0

let YKChatBarMinHeight = YKChatBarTextViewMinHeight + 2*YKChatBarBottomMargin
let YKTopLineBackgroundColor = UIColor.init(red: 104/255.0, green:  104/255.0, blue:  104/255.0, alpha: 1)

let YKChatBarButtonWidth = 35.0

let YKFunctionViewHeight = 210.0
let YKAnimateDuration = 0.25



class YKChatBar: UIView,UITextViewDelegate {

    //MARK: - ****** Property ******
    var showType: YKFunctionViewShowType = YKFunctionViewShowType.showNothing
    
    var keyBoardHeight: CGFloat = 0.0
    weak var delegate:YKChatBarDelegate?
    var oldTextViewHeight = YKChatBarTextViewMinHeight
    var parentViewController:UIViewController?
    
    
    
    //MARK: - ****** SubViews ******
    lazy var inputBarBackgroundView: UIView = {
        let inputBarBackgroundView = UIView.init()
        inputBarBackgroundView.backgroundColor = UIColor.white
        return inputBarBackgroundView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView.init()
        textView.font = UIFont.systemFont(ofSize: CGFloat(YKChatBarTextFontSize))
        textView.delegate = self
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).cgColor
        textView.returnKeyType = UIReturnKeyType.send
        textView.layer.masksToBounds = true
        return textView
    }()
    
    lazy var voiceButton: UIButton = {
        let voiceButton = UIButton.init(type: UIButtonType.custom)
        voiceButton.setBackgroundImage(UIImage.init(named: "ToolViewInputVoice"), for: UIControlState.normal)
        voiceButton.tag = YKFunctionViewShowType.showVoice.rawValue
        voiceButton.setBackgroundImage(UIImage.init(named: "ToolViewKeyboard"), for: UIControlState.selected)
        voiceButton.addTarget(self, action: #selector(buttonAction(button:)), for: UIControlEvents.touchUpInside)
        return voiceButton
    }()
    
    lazy var moreButton: UIButton = {
        let moreButton = UIButton.init(type: UIButtonType.custom)
        moreButton.setBackgroundImage(UIImage.init(named: "TypeSelectorBtn_Black"), for: UIControlState.normal)
        moreButton.setBackgroundImage(UIImage.init(named: "TypeSelectorBtn_Black"), for: UIControlState.selected)
        moreButton.addTarget(self, action: #selector(buttonAction(button:)), for: UIControlEvents.touchUpInside)
        moreButton.tag = YKFunctionViewShowType.showMore.rawValue
        return moreButton
    }()

    lazy var faceButton: UIButton = {
        let faceButton = UIButton.init(type: UIButtonType.custom)
        faceButton.setBackgroundImage(UIImage.init(named: "ToolViewEmotion"), for: UIControlState.normal)
        faceButton.setBackgroundImage(UIImage.init(named: "ToolViewKeyboard"), for: UIControlState.selected)
        faceButton.addTarget(self, action: #selector(buttonAction(button:)), for: UIControlEvents.touchUpInside)
        faceButton.tag = YKFunctionViewShowType.showFace.rawValue
        return faceButton
    }()

    lazy var voiceRecordButton: UIButton = {
        
        let voiceRecordBt = UIButton.init(type: UIButtonType.custom)
        voiceRecordBt.isHidden = true
        
        let edgeInsets = UIEdgeInsetsMake(9, 9, 9, 9)
        
        let normalBackgroundImage = UIImage.init(named: "VoiceBtn_Black")?.resizableImage(withCapInsets: edgeInsets, resizingMode: UIImageResizingMode.stretch)
        let highlightBackgroundImage = UIImage.init(named: "VoiceBtn_BlackHL")?.resizableImage(withCapInsets: edgeInsets, resizingMode: UIImageResizingMode.stretch)
        
        voiceRecordBt.setBackgroundImage(normalBackgroundImage, for: UIControlState.normal)
        voiceRecordBt.setBackgroundImage(highlightBackgroundImage, for: UIControlState.highlighted)
        
        voiceRecordBt.setTitle("按住 说话", for: UIControlState.normal)
        voiceRecordBt.setTitle("松开 结束", for: UIControlState.highlighted)
        
        voiceRecordBt.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        voiceRecordBt.setTitleColor(UIColor.darkGray, for: .normal)
        
        return voiceRecordBt
    }()
    
    lazy var faceView: YKChatFaceView = {
        let faceView = YKChatFaceView.init(frame: CGRect.zero)
        faceView.isHidden = true
        return faceView
    }()
    
    lazy var moreView: YKChatMoreView = {
        let moreView = YKChatMoreView.init(frame: CGRect.zero)
        moreView.isHidden = true
        moreView.moreTitleImages = ["照片","拍摄","123","123","123","123","123","123","123","123","123","123","123"]
        moreView.parentViewController = self.parentViewController
        moreView.chatBar = self
        return moreView
    }()
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init(frame: CGRect,parentViewController:UIViewController?) {
        super.init(frame: frame)
        self.parentViewController = parentViewController
        self.setUpUI()
    }
    
    func setUpUI() {
        
        self.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(self.inputBarBackgroundView)
        self.inputBarBackgroundView.addSubview(self.textView)
        self.inputBarBackgroundView.addSubview(self.voiceButton)
        self.inputBarBackgroundView.addSubview(self.faceButton)
        self.inputBarBackgroundView.addSubview(self.moreButton)
        self.inputBarBackgroundView.addSubview(self.voiceRecordButton)
        self.addSubview(self.faceView)
        self.addSubview(self.moreView)
        
        
        let topLine = UIView.init()
        topLine.backgroundColor = YKTopLineBackgroundColor
        self.inputBarBackgroundView.addSubview(topLine)
        
        topLine.snp.makeConstraints { (make) in
            
            make.left.right.top.equalTo(0)
            make.height.equalTo(0.5)
        }
        self.setUpConstant()
        self.registerNotification()
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

    }
    
    func setUpConstant() {
        
        self.inputBarBackgroundView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        
        self.voiceButton.snp.makeConstraints { (make) in
            make.left.equalTo(YKChatBarLeftRightMargin)
            make.width.height.equalTo(YKChatBarButtonWidth)
            make.bottom.equalTo(-YKChatBarButtonTopMargin)
        }
        
        self.textView.snp.makeConstraints { (make) in
            make.left.equalTo(self.voiceButton.snp.right).offset(YKChatBarButtonTopMargin)
            make.top.equalTo(YKChatBarBottomMargin)
            make.bottom.equalTo(-YKChatBarBottomMargin)
            make.height.equalTo(YKChatBarTextViewMinHeight)
        }
        
        self.faceButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.voiceButton.snp.bottom)
            make.left.equalTo(self.textView.snp.right).offset(YKChatBarButtonTopMargin)
            make.width.height.equalTo(YKChatBarButtonWidth)
        }
        
        self.moreButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.voiceButton.snp.bottom)
            make.left.equalTo(self.faceButton.snp.right).offset(YKChatBarBottomMargin)
            make.right.equalTo(-YKChatBarLeftRightMargin)
            make.width.height.equalTo(YKChatBarButtonWidth)
        }
        
        let voiceRecordButtoInsets:CGFloat = -5.0
        self.voiceRecordButton.snp.makeConstraints { (make) in
            make.edges.equalTo(self.textView).inset(UIEdgeInsetsMake(voiceRecordButtoInsets, voiceRecordButtoInsets, voiceRecordButtoInsets, voiceRecordButtoInsets))
        }
        
        self.faceView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.snp.bottom).offset(0)
            make.height.equalTo(YKFunctionViewHeight)
        }
        
        self.moreView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.snp.bottom).offset(0)
            make.height.equalTo(YKFunctionViewHeight)
        }
    }
    
    //MARK: - ****** Keyboard ******
   @objc func keyboardWillHidden(notification:NSNotification) {
        
        self.keyBoardHeight = 0.0
        
        if self.showType == .showKeyboard {
            self.showType = .showNothing
        }
        
        self.updateChatBarKeyBoardConstraint()
        self.handleShowType()
    }
    
   @objc func keyboardWillShow(notification:NSNotification) {
        
        let oldHeight = self.keyBoardHeight
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary;
        let keyBoardInfo: NSValue? = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue;
        self.keyBoardHeight = (keyBoardInfo?.cgRectValue.size.height)!; //键盘最终的高度
        
        if self.keyBoardHeight != oldHeight {
            showType = .showNothing
        }
        
        if self.keyBoardHeight == 0 {
            showType = .showNothing
            return
        }
        
        self.showType = .showKeyboard
        
        self.handleShowType()
        
        self.updateChatBarKeyBoardConstraint()
    }
    
    func updateChatBarKeyBoardConstraint() {
        
        let intputBarHeight = self.inputBarBackgroundView.frame.size.height

        let showHeight = intputBarHeight+self.keyBoardHeight
        
        self.handleSelfHeight(showHeight: showHeight)
    }
    
    
    //MARK: - ****** Private Methods ******
    @objc func buttonAction(button: UIButton) {
        
        if button == self.faceButton {
            self.faceButton.isSelected = !self.faceButton.isSelected
            self.moreButton.isSelected = false
            self.voiceButton.isSelected = false
        }else if button == self.moreButton {
            self.moreButton.isSelected = !self.moreButton.isSelected
            self.faceButton.isSelected = false
            self.voiceButton.isSelected = false

        }else if button == self.voiceButton {
            self.voiceButton.isSelected = !self.voiceButton.isSelected
            self.moreButton.isSelected = false
            self.faceButton.isSelected = false
        }
        
        if !button.isSelected {
            self.showType = YKFunctionViewShowType.showKeyboard
        }else{
            self.showType = YKFunctionViewShowType(rawValue: button.tag)!
        }
        
        self.handleShowType()
    }
    
    
    func handleShowType() {
        
        self.showOtherView(show: self.showType.rawValue>1)
        
        self.showVoiceView(show: self.showType == .showVoice && self.voiceButton.isSelected)
        
        self.showFaceView(show: self.showType == .showFace && self.faceButton.isSelected)
        
        self.showMoreView(show: self.showType == .showMore && self.moreButton.isSelected)
        
        switch showType {
        case .showNothing:
            self.textView.resignFirstResponder()

        case .showVoice:
            self.textView.text = nil
            self.textView.resignFirstResponder()
            
        case .showMore:
            self.textView.resignFirstResponder()
        case .showFace:
            self.textView.resignFirstResponder()
        case .showKeyboard:
            self.beginInputing()
            break
        }
    }
    //是否显示底部其他View
    func showOtherView(show:Bool) {
        
        let intputBarHeight = self.inputBarBackgroundView.frame.size.height
        
        let showHeight = ((show ? CGFloat( YKFunctionViewHeight) : 0) + intputBarHeight)
        
        self.handleSelfHeight(showHeight: showHeight)
    }
    
    func handleSelfHeight (showHeight:CGFloat) {
        self.snp.updateConstraints { (make) in
            make.height.equalTo(showHeight)
        }
        UIView.animate(withDuration: YKAnimateDuration) { 
            self.layoutIfNeeded()
        }
        
        
        self.chatBarFrameDidChangeShouldScrollToBottom(shouldScrollToBottom: true)
    }
    
    func showVoiceView(show:Bool) {
        self.voiceButton.isSelected = show
        self.voiceRecordButton.isSelected = show
        self.voiceRecordButton.isHidden = !show
        self.textView.isHidden = !self.voiceRecordButton.isHidden
    }
    
    func showFaceView(show:Bool) {
        
        self.faceView.isHidden = !show
        
        self.faceView.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.bottom).offset(show ? -YKFunctionViewHeight : 0)
        }
        
            UIView.animate(withDuration: YKAnimateDuration, animations: {
                
                self.layoutIfNeeded()
            })
    }
    
    func showMoreView(show: Bool) {
        self.moreView.isHidden = !show
        
        self.moreView.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.bottom).offset(show ? -YKFunctionViewHeight : 0)
        }
        
        UIView.animate(withDuration: YKAnimateDuration, animations: {
            
            self.layoutIfNeeded()
        })
    }
    
    //MARK: - ****** UITextViewDelegate ******
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.sendTextMessage(text: textView.text)
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.handleInputTextViewHeight()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.faceButton.isSelected = false
        self.moreButton.isSelected = false
        self.voiceButton.isSelected = false
        
        self.showFaceView(show: false)
        self.showMoreView(show: false)
        self.showVoiceView(show: false)
        return true
    }
    
    func handleInputTextViewHeight() {
        
        let textViewFrame = self.textView.frame
        
        let textSize = self.textView.sizeThatFits(CGSize.init(width: textViewFrame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        textView.isScrollEnabled = textSize.height > CGFloat(YKChatBarTextViewMinHeight)
        
        
        let netTextViewHeight = max(YKChatBarTextViewMinHeight, min(YKChatBarTextViewMaxHeight, Double(textSize.height)))
        
        let textViewHeightChanged = (self.oldTextViewHeight != netTextViewHeight)
        
        if textViewHeightChanged {
            self.oldTextViewHeight = netTextViewHeight
            
            let showHeight = CGFloat(netTextViewHeight) + self.keyBoardHeight + CGFloat(2*YKChatBarBottomMargin)
        
           self.handleSelfHeight(showHeight: showHeight)
           
            self.textView.snp.updateConstraints({ (make) in
                make.height.equalTo(netTextViewHeight)
            })
            
            func setContentOffBlock() {
                
                if textView.isScrollEnabled {
                    if netTextViewHeight == YKChatBarTextViewMaxHeight {
                        textView.setContentOffset(CGPoint.init(x: 0, y:Double(textView.contentSize.height) - netTextViewHeight), animated: true)
                    }else{
                        textView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                    }
                }
            }
            //在输入换行的时候，textView的内容向上偏移，再下次输入后恢复正常，原因是高度变化后，textView更新约束，重新设置了contentOffset；我是在设置contentOffset做了0.01秒的延迟，发现能解决这个问题
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.01, execute: {
            setContentOffBlock()
        })
            
        }
    }
    
    
    func chatBarFrameDidChangeShouldScrollToBottom(shouldScrollToBottom: Bool) {
        delegate?.chatBarFrameDidChangeShouldScrollToBottom!(chatbar: self, shouldScrollToBottom: shouldScrollToBottom)
    }
    
    func sendTextMessage(text:String) {
        
        if text.isEmpty {
            return
        }
        
        if let theMethod = delegate?.chatBarSendMessage {
            theMethod(self, text)
            self.textView.text = ""
            self.handleInputTextViewHeight()
        }
    }
    
    
    //MARK: - ****** Public Methods ******
    func beginInputing() {
        self.textView.becomeFirstResponder()
    }

    func endInputing() {
        if self.voiceButton.isSelected {
            return
        }
        faceButton.isSelected = false
        moreButton.isSelected = false
        voiceButton.isSelected = false
        //避免默认隐藏键盘 滑动依然自动返回底部bug
        if showType == .showNothing {
            return
        }
        
        showType = .showNothing
        
        self.handleShowType()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
