//
//  DesignsViewController.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 2/7/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import AlamofireImage

class DesignsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var campaignRoots: [CampaignRoot] = []

    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 32.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getCampaigns()
    }
    
    func getCampaigns(searchTerm: String? = nil, filters: [String] = []) {
        let client = TSAPI(token: defaults.stringForKey("user.token")!)
        
        client.getCampaigns(searchTerm, successCallback: {responseDictionary in
            for element in (responseDictionary["campaign_roots"]! as! [NSDictionary]) {
                let campaignRoot = CampaignRoot(dictionary: element)
                self.campaignRoots.append(campaignRoot)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.reloadData()
            },
            errorCallback: { dictionary in
                // handle error
        })        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! CampaignRootCell
        let indexPath = tableView.indexPathForCell(cell)
        let campaignRoot = campaignRoots[indexPath!.row]
        let detailViewController = segue.destinationViewController as! DesignDetailViewController
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        detailViewController.navigationItem.title = campaignRoot.name
        
        self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        detailViewController.campaignRoot = campaignRoot
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return campaignRoots.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CampaignRootCell", forIndexPath: indexPath) as! CampaignRootCell
        let campaignRoot = campaignRoots[indexPath.row]
        
        cell.nameLabel.text = campaignRoot.name
        cell.soldCountLabel.text = campaignRoot.soldDescription
        Alamofire.request(.GET, campaignRoot.designURL!)
            .responseImage { response in
                if let image = response.result.value {
                    cell.designImage.image = image
                }
        }
        
        return cell
    }
}
