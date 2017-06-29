//
//  YKChatMoreView.swift
//  BeginChat
//
//  Created by bestkai on 2017/5/5.
//  Copyright © 2017年 YunKai Wang. All rights reserved.
//

import UIKit


class YKMoreItemView: UIView {
    
    var title:String? {
        didSet{
            self.button.setTitle(title, for: .normal)
            self.titleLabel.text = title
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(UIColor.colorWithRGBValue(rgbValue: 0x888888), for: .normal)
        button.backgroundColor = UIColor.white
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.colorWithRGBValue(rgbValue: 0x888888)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.button)
        self.addSubview(self.titleLabel)
        self.isUserInteractionEnabled = true
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        
        self.button.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX).offset(self.width/2)
            make.top.equalTo(0)
            make.width.height.equalTo(60)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.button.snp.centerX)
            make.top.equalTo(self.button.snp.bottom).offset(6)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class YKChatMoreView: UIView,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let numberOfPerLine = 4
    let lineMargin = 15
    let contentLeftMargin = CGFloat(15)
    let contentTopMargin = 14.0
    
    var parentViewController:UIViewController?
    var chatBar:YKChatBar?

    
    lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController.init()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        return imagePickerController
    }()
    
    lazy var cameraController: UIImagePickerController = {
        let cameraController = UIImagePickerController.init()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        return cameraController
    }()
    
    
    var moreTitleImages:Array<String>? {
        didSet {
            self.reloadData()
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl.init()
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.white
        return pageControl
    }()
    
    lazy var topLine: UIView = {
        let topLine = UIView.init()
        topLine.backgroundColor = UIColor.colorWithRGBValue(rgbValue: 0xd7d7d9)
        return topLine
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.colorWithRGBValue(rgbValue: 0xf5f5f6)
        
        self.setUpUI()
    }
    
    func setUpUI() {
        self.addSubview(self.scrollView)
        self.addSubview(self.pageControl)
        self.addSubview(self.topLine)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        self.pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        self.topLine.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    
    func reloadData() {
        
        var line = 0//hang
        var colum = 0//lie
        var page = 0 //ye
        
        let itemHeight = CGFloat((YKFunctionViewHeight - contentTopMargin*2)/2.0)
        let scrollViewWidth = ScreenWidth
        let itemWidth = (scrollViewWidth - contentLeftMargin*2)/CGFloat(numberOfPerLine)
        
        for (index,title) in (self.moreTitleImages?.enumerated())! {
            
            if colum > 3 {
                line = line+1
                colum = 0
            }
            
            if line > 1 {
                line = 0
                colum = 0
                page = page+1
            }
            
            let startX = CGFloat(colum)*itemWidth + CGFloat(page)*scrollViewWidth
            let startY = CGFloat(line)*CGFloat(itemHeight)
            
            let item:YKMoreItemView = YKMoreItemView.init(frame: CGRect.init(x: contentLeftMargin + startX, y:CGFloat(contentTopMargin)+startY, width: itemWidth, height: itemHeight))
            item.tag = index
            item.title = title
            
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(itemViewTapped(gesture:)))
            
            item.addGestureRecognizer(gesture)
            self.scrollView.addSubview(item)
            
            colum = colum+1
            
            if index == (self.moreTitleImages?.count)! - 1 {
                self.scrollView.contentSize = CGSize.init(width: Double(ScreenWidth*CGFloat(page+1)), height: YKFunctionViewHeight)
                self.pageControl.numberOfPages = page+1
            }
        }
    }
    
    
   @objc func itemViewTapped(gesture:UITapGestureRecognizer)  {
        let itemView:YKMoreItemView = gesture.view as! YKMoreItemView
    
    switch itemView.tag {
    case 0:
        self.openImagePickerViewController()
    case 1:
        self.openCamera()
    default:
        break
    }
    }
    
    //打开图片选择器
    func openImagePickerViewController() {
        
        self.parentViewController?.present(self.imagePickerController, animated: true, completion: nil)
    }
    //打开相机
    func openCamera() {
        self.parentViewController?.present(self.cameraController, animated: true, completion: nil)
    }
    
    
    //MARK: - ****** UIScrollViewDelegate ******
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
    }
    
    
    
    //MARK: - ****** UIImagePickerControllerDelegate ******
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        
        let originImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let method = chatBar?.delegate?.chatBarSendImageMessage {
            method(originImage)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
