//
//  SectionData.swift
//  FlightInfo
//
//  Created by Kevin Smith on 22/7/18.
//  Copyright © 2018 Kevin Smith. All rights reserved.
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
