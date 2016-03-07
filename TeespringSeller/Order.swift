//
//  Order.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 2/7/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import Foundation

class Order {
    let buyerName: String?
    let createdAt: NSDate?
    let quantity: Int?
    let campaignName: String?
    
    init(dictionary: NSDictionary) {
        let buyerFirstName = dictionary["buyer_first_name"] as? String
        let buyerLastInitial = dictionary["buyer_last_name"] as? String
        let buyerFullName = "\(buyerFirstName ?? "") \(buyerLastInitial ?? "")"
        buyerName = (buyerFullName == "" ? "Someone" : buyerFullName)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd\'T'HH:mm:ss\'Z'+0000"
        createdAt = formatter.dateFromString(dictionary["ordered_at"] as! String)! as NSDate
        quantity = dictionary["quantity"] as? Int
        campaignName = dictionary["campaign_name"] as? String
    }
}

