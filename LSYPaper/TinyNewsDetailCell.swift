//
//  TinyNewsDetailCell.swift
//  FlightInfo
//
//  Created by Kevin Smith on 22/7/18.
//  Copyright © 2018 Kevin Smith. All rights reserved.
//

import UIKit

public let tinyBottomViewDefaultHeight:CGFloat = TINY_RATIO * bottomViewDefaultHeight

class TinyNewsDetailCell: UICollectionViewCell {

    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var newsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = cellGap
        newsView.layer.shadowColor = UIColor.black.cgColor
        newsView.layer.shadowOffset = CGSize(width: 0, height: 1)
        newsView.layer.shadowOpacity = 0.5
        newsView.layer.shadowRadius = 0.5
    }

}
