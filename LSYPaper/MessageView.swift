//
//  MessageView.swift
//  FlightInfo
//
//  Created by Kevin Smith on 22/7/18.
//  Copyright © 2018 Kevin Smith. All rights reserved.
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
