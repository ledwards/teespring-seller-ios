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
    let active_profit: Double?
    
    let active_products_reserved_today: Int?
    let profit_made_today: Double?
    
    let active_products_reserved_yesterday: Int?
    let profit_made_yesterday: Double?
    
    let total_products_reserved: Int?
    let total_profit: Double?
    
    init(dictionary: NSDictionary) {
        active_products_reserved = dictionary["active_products_reserved"] as? Int ?? 0
        active_profit = dictionary["active_profit"] as? Double ?? 0.0
        active_products_reserved_today = dictionary["active_products_reserved_today"] as? Int ?? 0
        profit_made_today = dictionary["profit_made_today"] as? Double ?? 0.0
        active_products_reserved_yesterday = dictionary["active_products_reserved_yesterday"] as? Int ?? 0
        profit_made_yesterday = dictionary["profit_made_yesterday"] as? Double ?? 0.0
        total_products_reserved = dictionary["total_products_reserved"] as? Int ?? 0
        total_profit = dictionary["total_profit"] as? Double ?? 0.0
    }
    
}
