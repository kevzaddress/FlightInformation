//
//  NewsDetailCell.swift
//  LSYPaper
//
//  Created by 梁树元 on 1/9/16.
//  Copyright © 2016 allsome.love. All rights reserved.
//

import UIKit
import AVFoundation

public let bottomViewDefaultHeight:CGFloat = 55
 let transform3Dm34D:CGFloat = 1900.0
 let newsViewWidth:CGFloat = (SCREEN_WIDTH - 50) / 2
 let shiningImageHeight:CGFloat = (SCREEN_WIDTH - 50) * 296 / 325
 let newsViewY:CGFloat = SCREEN_HEIGHT - 20 - bottomViewDefaultHeight - newsViewWidth * 2
 let endAngle:CGFloat = CGFloat(M_PI) / 2.5
 let startAngle:CGFloat = CGFloat(M_PI) / 3.3
 let animateDuration:Double = 0.25
 let miniScale:CGFloat = 0.97
 let maxFoldAngle:CGFloat = 1.0
 let minFoldAngle:CGFloat = 0.75
 let translationYForView:CGFloat = SCREEN_WIDTH - newsViewY
 let normalScale:CGFloat = SCREEN_WIDTH / (newsViewWidth * 2)
 let baseShadowRedius:CGFloat = 50.0
 let emitterWidth:CGFloat = 35.0

 let realShiningBGColor:UIColor = UIColor(white: 0.0, alpha: 0.4)

class BigNewsDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var upperScreenShot: UIImageView!
    @IBOutlet weak var baseScreenShot: UIImageView!
    @IBOutlet weak var baseLayerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var realShiningView: UIView!
    @IBOutlet weak var realBaseView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var shiningViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var newsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var coreViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shiningView: UIView!
    @IBOutlet weak var shiningImage: UIImageView!
    @IBOutlet weak var baseLayerView: UIView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var newsView: UIView!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var labelView: UIView!
    
     var panNewsView:UIPanGestureRecognizer = UIPanGestureRecognizer()
     var panWebView:UIPanGestureRecognizer = UIPanGestureRecognizer()
     var tapSelf:UITapGestureRecognizer = UITapGestureRecognizer()

     var topLayer:CALayer = CALayer()
     var bottomLayer:CALayer = CALayer()
     var isHasRequest:Bool = false
     var isLike:Bool = false
     var isShare:Bool = false {
        didSet {
            if isShare == true {
                LSYPaperPopView.showPopViewWith(CGRect(x: 0, y: SCREEN_HEIGHT - 47 - sharePopViewHeight, width: SCREEN_WIDTH, height: sharePopViewHeight), viewMode: LSYPaperPopViewMode.share,inView: totalView, frontView: bottomView, revokeOption: { () -> Void in
                    self.shareButton.addPopSpringAnimation()
                    self.revokePopView()
                })
            }else {
                LSYPaperPopView.hidePopView(totalView)
            }
        }
    }
     var isComment:Bool = false {
        didSet {
            if isComment == true {
                LSYPaperPopView.showPopViewWith(CGRect(x: 0, y: SCREEN_HEIGHT - commentPopViewHeight - 47, width: SCREEN_WIDTH, height: commentPopViewHeight), viewMode: LSYPaperPopViewMode.comment,inView: totalView, frontView: bottomView,revokeOption: { () -> Void in
                    self.revokePopView()
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.labelView.alpha = 1.0
                        }, completion: { (stop:Bool) -> Void in
                            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                                self.labelView.alpha = 0.0
                            })
                    })
                    })
            }else {
                LSYPaperPopView.hidePopView(totalView)
            }
        }
    }

    var isDarkMode:Bool = false {
        didSet {
            if isDarkMode == true {
                tapSelf.isEnabled = true
                sendCoreViewToBack()
                LSYPaperPopView.showBackgroundView(totalView)
                if isLike == false {
                    likeButton.setImage(UIImage(named: "LikePhoto"), for: UIControlState())
                }
                commentButton.setImage(UIImage(named: "CommentPhoto"), for: UIControlState())
                shareButton.setImage(UIImage(named: "SharePhoto"), for: UIControlState())
                summaryLabel.textColor = UIColor.white
                commentLabel.textColor = UIColor.white
            }else {
                tapSelf.isEnabled = false
                LSYPaperPopView.hideBackgroundView(totalView, completion: { () -> Void in
                    self.bringCoreViewToFront()
                })
                if isLike == false {
                    likeButton.setImage(UIImage(named: "Like"), for: UIControlState())
                }
                commentButton.setImage(UIImage(named: "Comment"), for: UIControlState())
                shareButton.setImage(UIImage(named: "Share"), for: UIControlState())
                summaryLabel.textColor = UIColor.lightGray
                commentLabel.textColor = UIColor.lightGray
            }
        }
    }

     var locationInSelf:CGPoint = CGPoint.zero
     var translationInSelf:CGPoint = CGPoint.zero
     var velocityInSelf:CGPoint = CGPoint.zero
     var transform3D:CATransform3D = CATransform3DIdentity
     var transformConcat:CATransform3D {
        return CATransform3DConcat(CATransform3DRotate(transform3D, transform3DAngle, 1, 0, 0), CATransform3DMakeTranslation(translationInSelf.x, 0, 0))
    }
     var foldScale:CGFloat {
        let a = (normalScale - 1) / ((maxFoldAngle - minFoldAngle) * CGFloat(M_PI))
        let b = 1 - (normalScale - 1) * minFoldAngle / (maxFoldAngle - minFoldAngle)
        return a * transform3DAngleFold + b <= 1 ? 1 : a * transform3DAngleFold + b
    }
     var transformConcatFold:CATransform3D {
        return CATransform3DConcat(CATransform3DConcat(CATransform3DRotate(transform3D, transform3DAngleFold, 1, 0, 0), CATransform3DMakeTranslation(translationInSelf.x / foldScale, translationYForView / foldScale, 0)), CATransform3DMakeScale(foldScale, foldScale, 1))
    }
     var transformEndedConcat:CATransform3D {
        let scale = normalScale
        return CATransform3DConcat(CATransform3DConcat(CATransform3DRotate(transform3D, CGFloat(M_PI), 1, 0, 0), CATransform3DMakeTranslation(0, translationYForView / scale, 0)), CATransform3DMakeScale(scale, scale, 1))
    }
     var transform3DAngle:CGFloat {
        let cosUpper = locationInSelf.y - newsViewY >= (newsViewWidth * 2) ? (newsViewWidth * 2) : locationInSelf.y - newsViewY
        return acos(cosUpper / (newsViewWidth * 2))
            + asin((locationInSelf.y - newsViewY) / transform3Dm34D)
    }
     var transform3DAngleFold:CGFloat {
        let cosUpper = locationInSelf.y - SCREEN_WIDTH
        return acos(cosUpper / SCREEN_WIDTH)
    }
     var webViewRequest:URLRequest {
        return URLRequest(url: URL(string: "https://github.com")!)
    }
    
     var soundID:SystemSoundID {
        var soundID:SystemSoundID = 0
        let path = Bundle.main.path(forResource: "Pop", ofType: "wav")
        let baseURL = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(baseURL as CFURL, &soundID)
        return soundID
    }
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var coreView: UIView!
    
     var explosionLayer:CAEmitterLayer = CAEmitterLayer()
     var chargeLayer:CAEmitterLayer = CAEmitterLayer()
    
    var unfoldWebViewOption:(() -> Void)?
    var foldWebViewOption:(() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = CORNER_REDIUS
        
        labelView.layer.masksToBounds = true
        labelView.layer.cornerRadius = CORNER_REDIUS
        totalView.layer.masksToBounds = true
        totalView.layer.cornerRadius = cellGap * 2
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 1.0
        baseLayerView.layer.shadowColor = UIColor.black.cgColor
        baseLayerView.layer.shadowOffset = CGSize(width: 0, height: baseShadowRedius)
        baseLayerView.layer.shadowOpacity = 0.8
        baseLayerView.layer.shadowRadius = baseShadowRedius
        baseLayerView.alpha = 0.0
        newsView.layer.shadowColor = UIColor.clear.cgColor
        newsView.layer.shadowOffset = CGSize(width: 0, height: baseShadowRedius)
        newsView.layer.shadowOpacity = 0.4
        newsView.layer.shadowRadius = baseShadowRedius
        upperScreenShot.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 1, 0, 0)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(BigNewsDetailCell.handleNewsPanGesture(_:)))
        pan.delegate = self
        newsView.addGestureRecognizer(pan)
        panNewsView = pan
        let tap = UITapGestureRecognizer(target: self, action: #selector(BigNewsDetailCell.handleNewsTapGesture(_:)))
        newsView.addGestureRecognizer(tap)
        transform3D.m34 = -1 / transform3Dm34D
        webViewHeightConstraint.constant = SCREEN_WIDTH * 2
        webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, SCREEN_WIDTH * 2 - SCREEN_HEIGHT, 0)
        let webViewPan = UIPanGestureRecognizer(target: self, action: #selector(BigNewsDetailCell.handleWebPanGesture(_:)))
        webViewPan.delegate = self
        webView.addGestureRecognizer(webViewPan)
        panWebView = webViewPan
        let tapContent = UITapGestureRecognizer(target: self, action: #selector(BigNewsDetailCell.handleContentTapGesture(_:)))
        contentView.addGestureRecognizer(tapContent)
        tapContent.isEnabled = false
        tapSelf = tapContent
        // heavily refer to MCFireworksView by Matthew Cheok
        let explosionCell = CAEmitterCell()
        explosionCell.name = "explosion"
        explosionCell.alphaRange = 0.2
        explosionCell.alphaSpeed = -1.0
        explosionCell.lifetime = 0.5
        explosionCell.lifetimeRange = 0.0
        explosionCell.birthRate = 0
        explosionCell.velocity = 44.00
        explosionCell.velocityRange = 7.00
        explosionCell.contents = UIImage(named: "Sparkle")?.cgImage
        explosionCell.scale = 0.05
        explosionCell.scaleRange = 0.02
        
        let explosionLayer = CAEmitterLayer()
        explosionLayer.name = "emitterLayer"
        explosionLayer.emitterShape = kCAEmitterLayerCircle
        explosionLayer.emitterMode = kCAEmitterLayerOutline
        explosionLayer.emitterSize = CGSize(width: emitterWidth, height: 0)
        let center = CGPoint(x: likeView.bounds.midX, y: likeView.bounds.midY)
        
        explosionLayer.emitterPosition = center
        explosionLayer.emitterCells = [explosionCell]
        explosionLayer.masksToBounds = false
        
        likeView.layer.addSublayer(explosionLayer)
        self.explosionLayer = explosionLayer
        
        let chargeCell = CAEmitterCell()
        chargeCell.name = "charge"
        chargeCell.alphaRange = 0.20
        chargeCell.alphaSpeed = -1.0
        
        chargeCell.lifetime = 0.3
        chargeCell.lifetimeRange = 0.1
        chargeCell.birthRate = 0
        chargeCell.velocity = -60.0
        chargeCell.velocityRange = 0.00
        chargeCell.contents = UIImage(named: "Sparkle")?.cgImage
        chargeCell.scale = 0.05
        chargeCell.scaleRange = 0.02
        
        let chargeLayer = CAEmitterLayer()
        chargeLayer.name = "emitterLayer"
        chargeLayer.emitterShape = kCAEmitterLayerCircle
        chargeLayer.emitterMode = kCAEmitterLayerOutline
        chargeLayer.emitterSize = CGSize(width: emitterWidth - 10, height: 0)
        
        chargeLayer.emitterPosition = center
        chargeLayer.emitterCells = [chargeCell]
        chargeLayer.masksToBounds = false
        likeView.layer.addSublayer(chargeLayer)
        self.chargeLayer = chargeLayer
    }
    
    @objc func handleContentTapGesture(_ recognizer:UITapGestureRecognizer) {
        revokePopView()
    }
    
    @objc func handleNewsTapGesture(_ recognizer:UITapGestureRecognizer) {
        anchorPointSetting()
        baseLayerView.alpha = 1.0
        realBaseView.alpha = 0.5
        locationInSelf = CGPoint(x: 0, y: SCREEN_HEIGHT - 9.5)
        gestureStateChangedSetting(transform3DAngle)
        tapNewsView()
    }
    
    @objc func handleWebPanGesture(_ recognizer:UIPanGestureRecognizer) {
        locationInSelf = recognizer.location(in: self)
        translationInSelf = recognizer.translation(in: self)
        if recognizer.state == UIGestureRecognizerState.began {
            baseScreenShot.image = self.getSubImageFrom(self.getWebViewScreenShot(), frame: CGRect(x: 0, y: SCREEN_WIDTH, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
            upperScreenShot.image = self.getSubImageFrom(self.getWebViewScreenShot(), frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
            webView.scrollView.panGestureRecognizer.isEnabled = false
            webView.alpha = 0.0
            let ratio = (M_PI - Double(transform3DAngleFold)) / M_PI
            let alpha:CGFloat = transform3DAngleFold / CGFloat(M_PI) >= 0.5 ? 1.0 : 0.0
            UIView.animate(withDuration: (animateDuration * 2 + 0.2) * ratio, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.newsView.layer.transform = self.transformConcatFold
                self.shiningView.layer.transform = self.transformConcatFold
                self.baseLayerView.layer.transform = CATransform3DConcat(CATransform3DMakeScale(self.foldScale, self.foldScale, 1), CATransform3DMakeTranslation(self.translationInSelf.x, translationYForView, 0))
                
                self.newsView.layer.shadowColor = UIColor.black.cgColor
                self.realBaseView.alpha = 0.5
                self.realShiningView.alpha = 0.5
                self.upperScreenShot.alpha = alpha
                }, completion: { (stop:Bool) -> Void in
            })
        }else if recognizer.state == UIGestureRecognizerState.changed && webView.scrollView.panGestureRecognizer.isEnabled == false {
            newsView.layer.transform = transformConcatFold
            shiningView.layer.transform = transformConcatFold
            baseLayerView.layer.transform = CATransform3DConcat(CATransform3DMakeScale(foldScale, foldScale, 1), CATransform3DMakeTranslation(translationInSelf.x, translationYForView, 0))
            shiningImage.transform = CGAffineTransform(translationX: 0, y: shiningImageHeight + newsViewWidth * 2 * (transform3DAngleFold - startAngle) / (endAngle - startAngle))
            gestureStateChangedSetting(transform3DAngleFold)
        }else if (recognizer.state == UIGestureRecognizerState.cancelled || recognizer.state == UIGestureRecognizerState.ended) && webView.scrollView.panGestureRecognizer.isEnabled == false{
            webView.scrollView.panGestureRecognizer.isEnabled = true
            velocityInSelf = recognizer.velocity(in: self)
            if self.velocityInSelf.y < 0 {
                if transform3DAngleFold / CGFloat(M_PI) < 0.5 {
                    UIView.animate(withDuration: animateDuration * Double((CGFloat(M_PI) - transform3DAngleFold) / CGFloat(M_PI * 2)), delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                        self.newsView.layer.transform = CATransform3DConcat(CATransform3DRotate(self.transform3D, CGFloat(M_PI_2), 1, 0, 0),CATransform3DMakeTranslation(self.translationInSelf.x, translationYForView, 0))
                        self.shiningView.layer.transform = CATransform3DConcat(CATransform3DRotate(self.transform3D, CGFloat(M_PI_2), 1, 0, 0),CATransform3DMakeTranslation(self.translationInSelf.x, translationYForView, 0))
                        }, completion: { (stop:Bool) -> Void in
                            self.upperScreenShot.alpha = 1.0
                            self.shiningImage.alpha = 0.0
                            self.realShiningView.alpha = 1.0
                            self.shiningView.backgroundColor = UIColor.white
                            self.realShiningView.backgroundColor = realShiningBGColor
                            self.newsView.layer.shadowColor = UIColor.black.cgColor
                            self.shadowView.layer.shadowColor = UIColor.clear.cgColor
                            self.baseLayerView.layer.transform = CATransform3DConcat(CATransform3DMakeScale(self.foldScale, self.foldScale, 1), CATransform3DMakeTranslation(self.translationInSelf.x, translationYForView / ((normalScale)), 0))
                            UIView.animate(withDuration: animateDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                                self.newsView.layer.transform = self.transformEndedConcat
                                self.shiningView.layer.transform = self.transformEndedConcat
                                self.baseLayerView.layer.transform = CATransform3DConcat(CATransform3DMakeTranslation(0, translationYForView / ((normalScale)), 0),CATransform3DMakeScale(normalScale, normalScale, 1))
                                self.realBaseView.alpha = 0.0
                                self.realShiningView.alpha = 0.0
                                self.newsView.layer.shadowColor = UIColor.clear.cgColor
                                }, completion: { (stop:Bool) -> Void in
                                    if self.velocityInSelf.y <= 0 {
                                        if (self.unfoldWebViewOption != nil) {
                                            self.unfoldWebViewOption!()
                                        }
                                        self.webView.alpha = 1.0
                                        self.loadWebViewRequest()
                                    }
                            })
                    })
                }else {
                    baseLayerView.layer.transform = CATransform3DConcat(CATransform3DMakeScale(foldScale, foldScale, 1), CATransform3DMakeTranslation(translationInSelf.x, translationYForView / ((normalScale)), 0))
                    UIView.animate(withDuration: animateDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                        self.newsView.layer.transform = self.transformEndedConcat
                        self.shiningView.layer.transform = self.transformEndedConcat
                        self.baseLayerView.layer.transform = CATransform3DConcat(CATransform3DMakeTranslation(0, translationYForView / ((normalScale)), 0),CATransform3DMakeScale(normalScale, normalScale, 1))
                        self.shiningImage.alpha = 0.0
                        self.realBaseView.alpha = 0.0
                        self.realShiningView.alpha = 0.0
                        self.newsView.layer.shadowColor = UIColor.clear.cgColor
                        },completion: { (stop:Bool) -> Void in
                            if self.velocityInSelf.y <= 0 {
                                if (self.unfoldWebViewOption != nil) {
                                    self.unfoldWebViewOption!()
                                }
                                self.webView.alpha = 1.0
                                self.loadWebViewRequest()
                            }
                    })
                }
            }else {
                self.normalLayoutNewsView()
            }
        }
    }

    @objc func handleNewsPanGesture(_ recognizer:UIPanGestureRecognizer) {
        locationInSelf = recognizer.location(in: self)
        if recognizer.state == UIGestureRecognizerState.began {
            anchorPointSetting()
            translationInSelf = recognizer.translation(in: self)
            UIView.animate(withDuration: animateDuration * 2 + 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.newsView.layer.transform = self.transformConcat
                self.shiningView.layer.transform = self.transformConcat
                self.shiningImage.transform = CGAffineTransform(translationX: 0, y: shiningImageHeight + newsViewWidth * 2 * (self.transform3DAngle - startAngle) / (endAngle - startAngle))
                self.totalView.transform = CGAffineTransform(scaleX: miniScale, y: miniScale)
                self.baseLayerView.alpha = 1.0
                self.realBaseView.alpha = 0.5
                }, completion: { (stop:Bool) -> Void in
            })
        }else if recognizer.state == UIGestureRecognizerState.changed {
            translationInSelf = recognizer.translation(in: self)
            newsView.layer.transform = transformConcat
            shiningView.layer.transform = transformConcat
            baseLayerView.layer.transform = CATransform3DMakeTranslation(translationInSelf.x, 0, 0)
            shiningImage.transform = CGAffineTransform(translationX: 0, y: shiningImageHeight + newsViewWidth * 2 * (transform3DAngle - startAngle) / (endAngle - startAngle))
            gestureStateChangedSetting(transform3DAngle)
        }else if (recognizer.state == UIGestureRecognizerState.cancelled || recognizer.state == UIGestureRecognizerState.ended){
            velocityInSelf = recognizer.velocity(in: self)
            if self.velocityInSelf.y <= 0 {
                if transform3DAngle / CGFloat(M_PI) < 0.5 {
                    tapNewsView()
                }else {
                    UIView.animate(withDuration: animateDuration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                        self.newsView.layer.transform = self.transformEndedConcat
                        self.shiningView.layer.transform = self.transformEndedConcat
                        self.baseLayerView.layer.transform = CATransform3DConcat(CATransform3DMakeScale(normalScale, normalScale, 1), CATransform3DMakeTranslation(0, translationYForView, 0))
                        self.shiningImage.alpha = 0.0
                        self.realBaseView.alpha = 0.0
                        self.realShiningView.alpha = 0.0
                        self.newsView.layer.shadowColor = UIColor.clear.cgColor
                        },completion: { (stop:Bool) -> Void in
                            if (self.unfoldWebViewOption != nil) {
                                self.unfoldWebViewOption!()
                            }
                            self.webView.alpha = 1.0
                            self.loadWebViewRequest()
                    })
                }
            }else {
               self.normalLayoutNewsView()
            }
        }
    }
    
    func revokePopView() {
        isDarkMode = false
        if isShare == true {
            isShare = false
        }else {
            isComment = false
        }
    }
}

 extension BigNewsDetailCell {

    
    @IBAction func showCommentOrNot(_ sender: UIButton) {
        if isComment == false {
            if isDarkMode == false {
                isDarkMode = true
            }else {
                isShare = false
            }
        }else {
            isDarkMode = false
        }
        if sender.tag != 1 {
            commentButton.addSpringAnimation()
        }
        isComment = !isComment
    }
    
    @IBAction func showShareOrNot(_ sender: AnyObject) {
        if isShare == false {
            if isDarkMode == false {
                isDarkMode = true
            }else {
                isComment = false
            }
        }else {
            isDarkMode = false
        }
        shareButton.addSpringAnimation()
        isShare = !isShare
    }
    
    @IBAction func likeOrNot(_ sender: AnyObject) {
        if isLike == false {
            likeButton.addSpringAnimation(1.3, durationArray: [0.05,0.1,0.23,0.195,0.155,0.12], delayArray: [0.0,0.0,0.1,0.0,0.0,0.0], scaleArray: [0.75,1.8,0.8,1.0,0.95,1.0])
            chargeLayer.setValue(100, forKeyPath: "emitterCells.charge.birthRate")
            delay((0.05 + 0.1 + 0.23) * 1.3, closure: { () -> Void in
                self.chargeLayer.setValue(0, forKeyPath: "emitterCells.charge.birthRate")
                self.explosionLayer.setValue(1000, forKeyPath: "emitterCells.explosion.birthRate")
                self.delay(0.1, closure: { () -> Void in
                    self.explosionLayer.setValue(0, forKeyPath: "emitterCells.explosion.birthRate")
                })
                AudioServicesPlaySystemSound(self.soundID)
            })
            likeButton.setImage(UIImage(named: "Like-Blue"), for: UIControlState())
            self.commentLabel.text = "Awesome!"
            self.commentLabel.addFadeAnimation()
        }else {
            likeButton.addSpringAnimation()
            let image = isDarkMode == false ? UIImage(named: "Like") : UIImage(named: "LikePhoto")
            likeButton.setImage(image, for: UIControlState())
            self.commentLabel.text = "Write a comment"
            self.commentLabel.addFadeAnimation()
        }
        isLike = !isLike
    }
    
     func bringCoreViewToFront() {
        totalView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.clear
        contentView.bringSubview(toFront: coreView)
        contentView.bringSubview(toFront: webView)
    }
    
     func sendCoreViewToBack() {
        totalView.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.white
        contentView.sendSubview(toBack: coreView)
    }
    
     func loadWebViewRequest() {
        if self.isHasRequest == false {
            self.webView.loadRequest(self.webViewRequest)
            self.isHasRequest = true
        }
    }
     func anchorPointSetting() {
        newsView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        newsViewBottomConstraint.constant = newsViewWidth
        shiningView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        shiningViewBottomConstraint.constant = newsViewWidth
        baseLayerView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        baseLayerViewBottomConstraint.constant = newsViewWidth
    }
     func getWebViewScreenShot() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(webView.frame.size, false, 1.0)
        webView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
     func getSubImageFrom(_ originImage:UIImage,frame:CGRect) -> UIImage {
        let imageRef = originImage.cgImage
        let subImageRef = imageRef?.cropping(to: frame)
        UIGraphicsBeginImageContext(frame.size)
       
        let subImage = UIImage(cgImage: subImageRef!)
        UIGraphicsEndImageContext();
        return subImage;
    }
    
     func tapNewsView() {
        UIView.animate(withDuration: animateDuration * Double((CGFloat(M_PI) - transform3DAngleFold) / CGFloat(M_PI * 2)), delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.newsView.layer.transform = CATransform3DConcat(CATransform3DRotate(self.transform3D, CGFloat(M_PI_2), 1, 0, 0),CATransform3DMakeTranslation(self.translationInSelf.x, 0, 0))
            self.shiningView.layer.transform = CATransform3DConcat(CATransform3DRotate(self.transform3D, CGFloat(M_PI_2), 1, 0, 0),CATransform3DMakeTranslation(self.translationInSelf.x, 0, 0))
            self.shiningImage.transform = CGAffineTransform(translationX: 0, y: shiningImageHeight + newsViewWidth * 2 * (self.transform3DAngle - startAngle) / (endAngle - startAngle))
            }, completion: { (stop:Bool) -> Void in
                self.shiningImage.alpha = 0.0
                self.realShiningView.alpha = 0.5
                self.upperScreenShot.alpha = 1.0
                self.shiningView.backgroundColor = UIColor.white
                self.realShiningView.backgroundColor = realShiningBGColor
                self.newsView.layer.shadowColor = UIColor.black.cgColor
                self.shadowView.layer.shadowColor = UIColor.clear.cgColor
                UIView.animate(withDuration: animateDuration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    self.newsView.layer.transform = self.transformEndedConcat
                    self.shiningView.layer.transform = self.transformEndedConcat
                    self.baseLayerView.layer.transform = CATransform3DConcat(CATransform3DMakeScale(normalScale, normalScale, 1), CATransform3DMakeTranslation(0, translationYForView, 0))
                    self.realBaseView.alpha = 0.0
                    self.realShiningView.alpha = 0.0
                    self.newsView.layer.shadowColor = UIColor.clear.cgColor
                    }, completion: { (stop:Bool) -> Void in
                        if (self.unfoldWebViewOption != nil) {
                            self.unfoldWebViewOption!()
                        }
                        self.webView.alpha = 1.0
                        self.loadWebViewRequest()
                })
        })
    }
    
     func normalLayoutNewsView() {
        UIView.animate(withDuration: animateDuration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.newsView.layer.transform = CATransform3DIdentity
            self.shiningView.layer.transform = CATransform3DIdentity
            self.shiningImage.transform = CGAffineTransform.identity
            self.totalView.transform = CGAffineTransform.identity
            self.baseLayerView.layer.transform = CATransform3DIdentity
            self.shiningImage.alpha = 1.0
            self.baseLayerView.alpha = 0.0
            self.realShiningView.alpha = 0.0
            self.shiningView.backgroundColor = UIColor.clear
            self.newsView.layer.shadowColor = UIColor.clear.cgColor
            self.shadowView.layer.shadowColor = UIColor.black.cgColor
            },completion: { (stop:Bool) -> Void in
                if (self.foldWebViewOption != nil) {
                    self.foldWebViewOption!()
                }
        })
    }
    
     func gestureStateChangedSetting(_ targetAngle:CGFloat) {
        if targetAngle / CGFloat(M_PI) >= 0.5 {
            upperScreenShot.alpha = 1.0
            shiningImage.alpha = 0
            realShiningView.alpha = 0.5
            shiningView.backgroundColor = UIColor.white
            realShiningView.backgroundColor = realShiningBGColor
            newsView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowColor = UIColor.clear.cgColor
        }else {
            upperScreenShot.alpha = 0.0
            shiningImage.alpha = 1
            realShiningView.alpha = 0.0
            shiningView.backgroundColor = UIColor.clear
            newsView.layer.shadowColor = UIColor.clear.cgColor
            shadowView.layer.shadowColor = UIColor.black.cgColor
        }
    }
}

extension BigNewsDetailCell:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panWebView && otherGestureRecognizer == webView.scrollView.panGestureRecognizer {
            if (webView.scrollView.contentOffset.y <= 0 && webView.scrollView.panGestureRecognizer.velocity(in: self).y >= 0) || webView.scrollView.panGestureRecognizer.location(in: self).y <= 100 {
                return true
            }else {
                return false
            }
        } else {
            return false
        }
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panNewsView {
            if (panNewsView.velocity(in: self).y >= 0) || fabs(panNewsView.velocity(in: self).x) >= fabs(panNewsView.velocity(in: self).y) {
                return false
            }else {
                return true
            }
        }else {
            return true
        }
    }
}
