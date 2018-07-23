//
//  Constant.swift
//  FlightInfo
//
//  Created by Kevin Smith on 22/7/18.
//  Copyright © 2018 Kevin Smith. All rights reserved.
//

import UIKit

public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
public let POSTER_HEIGHT_RATIO:CGFloat = 5 / 9
public let POSTER_HEIGHT = SCREEN_HEIGHT * POSTER_HEIGHT_RATIO
public let CELL_NORMAL_HEIGHT = SCREEN_HEIGHT - POSTER_HEIGHT
public let CORNER_REDIUS:CGFloat = 6
public let TINY_RATIO:CGFloat = 0.44
public let WINDOW:UIWindow = UIApplication.shared.keyWindow!
