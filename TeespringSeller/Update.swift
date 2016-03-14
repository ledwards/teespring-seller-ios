//
//  Update.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 2/7/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import Foundation

class Update: NSObject {
    let message: String
    let type: UpdateType
    let createdAt: NSDate?
    let createdAgo: String?
    let order: Order?
    
    enum UpdateType {
        case Order
    }
    
    init(order: Order) {
        let name = order.buyerName
        let quantity = order.quantity == 1 ? "a" : String(order.quantity!)
        let campaignName = order.campaignName!
        let product = order.quantity == 1 ? "t-shirt" : "t-shirts"
        
        if let name = name {
            message = "\(name ?? "") bought \(quantity) \(campaignName) \(product)!"
        } else {
            message = "Someone bought \(quantity) \(campaignName) \(product)!"
        }
        type = .Order
        self.order = order
        createdAt = order.createdAt ?? NSDate()
        createdAgo = createdAt?.timeAgoInWords()
    }
}
