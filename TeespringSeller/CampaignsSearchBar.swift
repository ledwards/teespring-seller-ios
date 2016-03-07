//
//  CampaignsSearchBar.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 2/7/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class CampaignsSearchBar: UISearchBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for outerView in self.subviews {
            for view in outerView.subviews {
                let newHeight = CGFloat(36.0)
                let newY = (view.frame.size.height) / CGFloat(2.0) + newHeight
                
                if view.isKindOfClass(UITextField) {
                    view.frame = CGRectMake (view.frame.origin.x, newY, view.frame.size.width, newHeight)
                } else if view.isKindOfClass(UILabel) {
                    let label = view as! UILabel
                    let offset = CGFloat(10.0)
                    label.textColor = UIColor.whiteColor()
                    label.shadowColor = UIColor.clearColor()
                    view.frame = CGRectMake (view.frame.origin.x, view.frame.origin.y + offset, view.frame.size.width, view.frame.size.height)
                } else if view.isKindOfClass(UIButton) {
                    view.frame = CGRectMake (view.frame.origin.x, newY, view.frame.size.width, newHeight)
                }
            }
        }
    }
}
