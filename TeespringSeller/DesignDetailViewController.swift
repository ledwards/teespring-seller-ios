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
    @IBOutlet weak var tableView: UITableView!
    
    var campaignRoot: CampaignRoot? = nil
    var orders: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countFormatter = NSNumberFormatter()
        countFormatter.numberStyle = .DecimalStyle
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshCallback:", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        if let campaignRoot = campaignRoot {
            soldCountLabel.text = countFormatter.stringFromNumber(campaignRoot.totalSoldCount!)
            profitEarnedLabel.text = campaignRoot.totalPayoutAmount!.formattedAmount
            Alamofire.request(.GET, campaignRoot.designURL!)
                .responseImage { response in
                    if let image = response.result.value {
                        self.designImageView.image = image
                    }
            }
            getOrders(refreshControl)
        }
        
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getOrders(refreshControl: UIRefreshControl? = nil) {
        let client = TSAPI(token: NSUserDefaults.standardUserDefaults().stringForKey("user.token")!)
        
        client.getOrders({responseDictionary in
            for element in (responseDictionary["orders"]! as! [NSDictionary]) {
                    let order = Order(dictionary: element)
                    let existingOrders = self.orders.map{ u in u.createdAt! }
                    if let _ = existingOrders.indexOf(order.createdAt!) {
                        // nothing
                    } else {
                        self.orders.append(order)
                    }
            }
            
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
            
            self.tableView.reloadData()
            },
            errorCallback: { dictionary in
                // handle error
        })
        
        self.orders.sortInPlace{$0.createdAt!.compare($1.createdAt!) == NSComparisonResult.OrderedDescending}
    }
    
    func refreshCallback(refreshControl: UIRefreshControl) {
        getOrders(refreshControl)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "DesignDetailViewSegue":
                var indexPath: NSIndexPath? = nil
                if let cell = sender as? OrderCell {
                    indexPath = tableView.indexPathForCell(cell)
                    let order = self.orders[indexPath!.row]
                    let vc = segue.destinationViewController as! OrderDetailViewController
                    vc.order = order
                }
            case "CampaignWebViewSegue":
                let vc = segue.destinationViewController as! CampaignWebViewController
                if let webURL = self.campaignRoot!.webURL {
                    vc.url = webURL
                }
            default: break
            }
        }
    }
}

extension DesignDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell") as! OrderCell
        let order = orders[indexPath.row]
        cell.moneyLabel.text = order.amount!.formattedAmount
        cell.timeLabel.text = order.formattedDate
        cell.descriptionLabel.text = order.description
        cell.locationLabel.text = order.location
        return cell
    }
}
