//
//  Money.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 3/13/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import Foundation

class Money {
    let amount: Int
    let currency: String
    
    var formattedAmount: String {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        return currencyFormatter.stringFromNumber(Double(amount) / 100.0)!
    }
    
    init(dictionary: NSDictionary) {
        amount = dictionary["value"] as? Int ?? 0
        currency = dictionary["currency"] as? String ?? "USD"
    }
}