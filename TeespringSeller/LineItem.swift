//
//  LineItem.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 3/13/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import Foundation

class LineItem {
    let color: String?
    let price: Money?
    let productName: String?
    let quantity: Int?
    let size: String?
    
    var description: String {
        return "\(size!) \(color!) \(productName!)"
    }
    
    init(dictionary: NSDictionary) {
        color = dictionary["color"] as? String
        price = Money(dictionary: dictionary["price"] as! NSDictionary)
        productName = dictionary["product_name"] as? String
        quantity = dictionary["quantity"] as? Int
        size = dictionary["size"] as? String
    }
}