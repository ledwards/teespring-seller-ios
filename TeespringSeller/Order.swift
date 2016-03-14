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
    let shipCity: String
    let shipState: String
    let shipCountry: String
    var lineItems: [LineItem] = []
    let amount: Money?
    
    var description: String {
        let lineItem = lineItems.first
        if let lineItem = lineItem {
            if quantity == 1 {
                return lineItem.description
            } else {
                return "\(lineItem.size!) \(lineItem.color!) \(lineItem.productName!) and \(quantity! - 1) other items"
            }
        } else {
            if let quantity = quantity {
                return "An order of \(quantity) item(s)"
            } else {
                return "An order"
            }
        }
    }
    
    var location: String {
        if shipCity != "" && shipState != "" && shipCountry != "" {
            return "\(shipCity), \(shipState), \(shipCountry)"
        } else if shipCity != "" && shipCountry != "" {
            return "\(shipCity), \(shipCountry)"
        } else if shipCountry != "" {
            return shipCountry
        } else {
            return ""
        }
    }
    
    var formattedDate: String {
        return createdAt?.timeAgoInWords() ?? "Some time ago"
    }
    
    init(dictionary: NSDictionary) {
        quantity = dictionary["quantity"] as? Int
        campaignName = dictionary["campaign_name"] as? String
        shipCity = dictionary["ship_city"] as? String ?? ""
        shipState = dictionary["ship_state"] as? String ?? ""
        shipCountry = dictionary["ship_country"] as? String ?? ""
        amount = Money(dictionary: dictionary["order_amount"] as! NSDictionary)
        
        let buyerFirstName = dictionary["buyer_first_name"] as? String
        buyerName = buyerFirstName ?? "Someone"
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd\'T'HH:mm:ss\'Z'+0000"
        createdAt = formatter.dateFromString(dictionary["ordered_at"] as! String)! as NSDate
        
        let lineItemsDictionary = dictionary["line_items"] as! [NSDictionary]
        for (_, element) in lineItemsDictionary.enumerate() {
            lineItems.append(LineItem(dictionary: element) )
        }
    }
}

