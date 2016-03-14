//
//  Dashboard.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 2/7/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import Foundation

class Dashboard: NSObject {
    let active_products_reserved: Int?
    let active_profit: Money?
    
    let active_products_reserved_today: Int?
    let profit_made_today: Money?
    
    let active_products_reserved_yesterday: Int?
    let profit_made_yesterday: Money?
    
    let total_products_reserved: Int?
    let total_profit: Money?
    
    init(dictionary: NSDictionary) {
        active_products_reserved = dictionary["active_products_reserved"] as? Int ?? 0
        active_profit = Money(dictionary: dictionary["active_profit"] as! NSDictionary)
        active_products_reserved_today = dictionary["active_products_reserved_today"] as? Int ?? 0
        profit_made_today = Money(dictionary: dictionary["profit_made_today"] as! NSDictionary)
        active_products_reserved_yesterday = dictionary["active_products_reserved_yesterday"] as? Int ?? 0
        profit_made_yesterday = Money(dictionary: dictionary["profit_made_yesterday"] as! NSDictionary)
        total_products_reserved = dictionary["total_products_reserved"] as? Int ?? 0
        total_profit = Money(dictionary: dictionary["total_profit"] as! NSDictionary)
    }
    
}
