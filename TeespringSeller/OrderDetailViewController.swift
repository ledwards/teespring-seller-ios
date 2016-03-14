//
//  OrderDetailViewController.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 3/13/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

protocol OrderDetailViewControllerDelegate : class {
    func orderPickedOrder(controller: OrderDetailViewControllerDelegate, campaignRoot: CampaignRoot, order: Order)
}

class OrderDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var order: Order?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let order = order {
            titleLabel.text = order.campaignName
            amountLabel.text = order.amount?.formattedAmount
            timeLabel.text = order.formattedDate
            locationLabel.text = order.location
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension OrderDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.lineItems.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LineItemCell") as! LineItemCell
        let lineItem = order?.lineItems[indexPath.row]
        cell.descriptionLabel.text = lineItem?.description ?? "An unspecified item"
        cell.quantityLabel.text = String(lineItem?.quantity ?? 1)
        return cell
    }
}

extension OrderDetailViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        return nil
    }
}
