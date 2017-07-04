//
//  YKBadgeView.swift
//  BeginChat
//
//  Created by bestkai on 2017/7/3.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit


enum YKBadgeViewAlignment {
    case topLeft
    case topRight
    case topCenter
    case centerLeft
    case centerRight
    case bottomLeft
    case bottomRight
    case bottomCenter
    case center
}

let YKBadgeViewHeight = 18.0
let YKBadgeViewTextSideMargin = 8.0
let YKBadgeViewCornerRadius = YKBadgeViewHeight/2.0



class YKBadgeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
   private lazy var badgeLabel: UILabel = {
        let badgeLabel = UILabel.init()
        badgeLabel.textColor = self.badgeTextColor
        badgeLabel.font = self.badgeTextFont
        return badgeLabel
    }()
    
    
    var badgeText:String? {
        didSet {
            self.badgeLabel.text = badgeText
            self.updateFrame()
        }
    }
    var badgeAlignment = YKBadgeViewAlignment.topRight
    var badgeTextColor = UIColor.white {
        didSet {
            self.badgeLabel.textColor = badgeTextColor
        }
    }
    var badgeTextFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        didSet{
            badgeLabel.font = badgeTextFont
        }
    }
    var badgeBackgroundColor = UIColor.red {
        didSet{
            self.backgroundColor = badgeBackgroundColor
        }
    }
    //自定义大小
    var customFrame:CGRect? {
        didSet{
            if customFrame != nil {
                self.handleFrameBy(newFrame: customFrame!)
            }else{
                self.frame = CGRect.zero
                self.isHidden = true
            }
        }
    }
    
    
    /*
     相对视图，避免父视图裁剪造成badgeView显示不完整
     */
    var relativeView:UIView?
    
    
    init(relativeView:UIView, alignment:YKBadgeViewAlignment) {
        super.init(frame: CGRect.zero)
        self.badgeAlignment = alignment
        self.relativeView = relativeView
        
        relativeView.superview?.addSubview(self)
        
        self.setupSubViews()
    }
    
    func setupSubViews() {
        self.backgroundColor = self.badgeBackgroundColor
        self.addSubview(self.badgeLabel)
        self.layer.cornerRadius = CGFloat(YKBadgeViewCornerRadius)
        self.layer.masksToBounds = true
    }
    
    func updateFrame() {
        self.isHidden = (self.badgeText?.isEmpty)!||Int(self.badgeText ?? "0") == 0
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        self.badgeLabel.sizeToFit()
        
        let relativeViewOriginX = relativeView?.frame.origin.x
        let relativeViewOriginY = relativeView?.frame.origin.y
        
        
        let relativeViewWidth =   relativeView?.bounds.size.width
        let relativeViewHeight = relativeView?.bounds.size.height
        
        let textWidth = self.badgeLabel.frame.size.width
        
        var newFrame = self.frame
        
        let viewWidth = textWidth + CGFloat(YKBadgeViewTextSideMargin)
        let viewHeight = CGFloat(YKBadgeViewHeight)
        
        newFrame.size.width = max(viewWidth, viewHeight)
        newFrame.size.height = viewHeight
        
        switch self.badgeAlignment {
        case .topLeft:
            newFrame.origin.x = relativeViewOriginX! + -viewWidth/2.0
            newFrame.origin.y = relativeViewOriginY! + -viewHeight/2.0
        case .topRight:
            newFrame.origin.x = relativeViewOriginX! + relativeViewWidth! - viewWidth/2.0
            newFrame.origin.y = relativeViewOriginY! + -viewHeight/2.0
        case .topCenter:
            newFrame.origin.x = relativeViewOriginX! + (relativeViewWidth! - viewWidth)/2.0
            newFrame.origin.y = relativeViewOriginY! + -viewHeight/2.0
        case .bottomLeft:
            newFrame.origin.x = relativeViewOriginX! + -viewWidth/2.0
            newFrame.origin.y = relativeViewHeight! + relativeViewOriginY! + -viewHeight/2.0
        case.bottomRight:
            newFrame.origin.x = relativeViewOriginX! + relativeViewWidth! - viewWidth/2.0
            newFrame.origin.y = relativeViewHeight! + relativeViewOriginY! + -viewHeight/2.0
        case .bottomCenter:
            newFrame.origin.x = relativeViewOriginX! + (relativeViewWidth! - viewWidth)/2.0
            newFrame.origin.y = relativeViewHeight! + relativeViewOriginY! + -viewHeight/2.0
        case .center:
            newFrame.origin.x = relativeViewOriginX! + (relativeViewWidth! - viewWidth)/2.0
            newFrame.origin.y = relativeViewOriginY! + (relativeViewHeight! - viewHeight)/2.0
        case .centerLeft:
            newFrame.origin.x = relativeViewOriginX! + -viewWidth/2.0
            newFrame.origin.y = relativeViewOriginY! + (relativeViewHeight! - viewHeight)/2.0
        case .centerRight:
            newFrame.origin.x = relativeViewOriginX! + relativeViewWidth! - viewWidth/2.0
            newFrame.origin.y = relativeViewOriginY! + (relativeViewHeight! - viewHeight)/2.0
        }
        
        self.handleFrameBy(newFrame: newFrame)
    }
    
    func handleFrameBy(newFrame:CGRect) {
        self.frame = newFrame
        
        var badgeFrame = self.badgeLabel.frame
        
        badgeFrame.origin.x = (newFrame.width - badgeFrame.width)/2.0
        badgeFrame.origin.y = (newFrame.height - badgeFrame.height)/2.0
        
        self.badgeLabel.frame = badgeFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
