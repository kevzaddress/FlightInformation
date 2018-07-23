//
//  MessageView.swift
//  LSYPaper
//
//  Created by 梁树元 on 1/6/16.
//  Copyright © 2016 allsome.love. All rights reserved.
//

import UIKit

class MessageView: UIView {
    private var targetFrame:CGRect = CGRect.zero

    override func layoutSubviews() {
        frame = targetFrame
    }
    
    class func messageViewWith(frame:CGRect) -> MessageView {
        let objs = Bundle.main.loadNibNamed("MessageView", owner: nil, options: nil)
        let messageView = objs?.last as! MessageView
        messageView.targetFrame = frame
        messageView.frame = frame
        return messageView
    }

}
