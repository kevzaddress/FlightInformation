//
//  SectionData.swift
//  LSYPaper
//
//  Created by 梁树元 on 1/7/16.
//  Copyright © 2016 allsome.love. All rights reserved.
//

import UIKit

class SectionData: NSObject {
    
    @objc var subTitle:String = ""
    @objc var title:String = ""
    @objc var icon:String = ""
    @objc var standByIcon:String = ""
    
    init(dictionary:[String : AnyObject]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
}
