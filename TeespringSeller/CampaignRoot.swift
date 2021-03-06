//
//  Order.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 2/7/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import Foundation

class CampaignRoot {
    let name: String?
    let designURL: NSURL?
    let totalSoldCount: Int?
    let lastCampaignSoldCount: Int?
    let totalPayoutAmount: Money?
    let webURL: NSURL?
    
    var soldDescription: String {
        if let total = totalSoldCount, last = lastCampaignSoldCount {
            return "\(total) sold (\(last) sold this edition)"
        }
        else {
            return ""
        }
    }
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        designURL = NSURL(string: dictionary["design_thumbnail_url"] as! String)
        totalSoldCount = dictionary["total_units"] as? Int
        totalPayoutAmount = Money(dictionary: dictionary["total_payout_amount"] as! NSDictionary)
        if let slug = dictionary["slug"] {
            webURL = NSURL(string: "\(ROOT_WEB_URL)/\(slug)")
        } else {
            webURL = NSURL(string: "\(ROOT_WEB_URL)/notfound")
        }
        webURL?.absoluteString

        let campaigns = dictionary["campaigns"] as! [NSDictionary]
        lastCampaignSoldCount = campaigns.last!["units"] as? Int
    }
}

