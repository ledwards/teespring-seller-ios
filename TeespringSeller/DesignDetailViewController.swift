//
//  DesignDetailViewController.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 2/7/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DesignDetailViewController: UIViewController {
    @IBOutlet weak var designImageView: UIImageView!
    @IBOutlet weak var soldCountLabel: UILabel!
    @IBOutlet weak var profitEarnedLabel: UILabel!
    
    var campaignRoot: CampaignRoot? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currencyFormatter = NSNumberFormatter()
        let countFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        countFormatter.numberStyle = .DecimalStyle
        
        if let campaignRoot = campaignRoot {
            soldCountLabel.text = countFormatter.stringFromNumber(campaignRoot.totalSoldCount!)
            profitEarnedLabel.text = currencyFormatter.stringFromNumber(campaignRoot.totalPayoutAmount!)
            Alamofire.request(.GET, campaignRoot.designURL!)
                .responseImage { response in
                    if let image = response.result.value {
                        self.designImageView.image = image
                    }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
