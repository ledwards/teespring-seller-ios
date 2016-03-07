//
//  ViewController.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 2/4/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit
import MBProgressHUD

class DashboardViewController: UIViewController {
    @IBOutlet weak var soldCountView: UILabel!
    @IBOutlet weak var profitTotalView: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var yesterdayButton: UIButton!
    @IBOutlet weak var allTimeButton: UIButton!
    
    @IBAction func onPressActive(sender: UIButton) {
        self.selectedTimePeriod = .Active
        self.renderDashboard()
    }
    
    @IBAction func onPressToday(sender: UIButton) {
        self.selectedTimePeriod = .Today
        self.renderDashboard()
    }
    
    @IBAction func onPressYesterday(sender: UIButton) {
        self.selectedTimePeriod = .Yesterday
        self.renderDashboard()
    }
    
    @IBAction func onPressAllTime(sender: UIButton) {
        self.selectedTimePeriod = .AllTime
        self.renderDashboard()
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var dashboard: Dashboard! {
        didSet {
            renderDashboard()
        }
    }
    
    var updates: [Update] = []
    
    enum TimePeriod {
        case Active
        case Today
        case Yesterday
        case AllTime
    }
    var selectedTimePeriod = TimePeriod.Active
    var accessToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshCallback:", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .Plain, target: self, action: "searchPressed:")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func renderDashboard() {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        
        let countFormatter = NSNumberFormatter()
        countFormatter.numberStyle = .DecimalStyle
        
        for button in [self.activeButton, self.todayButton, self.yesterdayButton, self.allTimeButton] {
            button.titleLabel?.font = UIFont.systemFontOfSize(10.0)
        }
        
        switch selectedTimePeriod {
        case .Active:
            self.soldCountView.text = countFormatter.stringFromNumber(self.dashboard.active_products_reserved!)
            self.profitTotalView.text = currencyFormatter.stringFromNumber(self.dashboard.active_profit!)
            activeButton.titleLabel?.font = UIFont.boldSystemFontOfSize(10.0)
            
        case .Today:
            self.soldCountView.text = countFormatter.stringFromNumber(self.dashboard.active_products_reserved_today!)
            self.profitTotalView.text = currencyFormatter.stringFromNumber(self.dashboard.profit_made_today!)
            todayButton.titleLabel?.font = UIFont.boldSystemFontOfSize(10.0)
            
        case .Yesterday:
            self.soldCountView.text = countFormatter.stringFromNumber(self.dashboard.active_products_reserved_yesterday!)
            self.profitTotalView.text = currencyFormatter.stringFromNumber(self.dashboard.profit_made_yesterday!)
            yesterdayButton.titleLabel?.font = UIFont.boldSystemFontOfSize(10.0)
            
        case .AllTime:
            self.soldCountView.text = countFormatter.stringFromNumber(self.dashboard.total_products_reserved!)
            self.profitTotalView.text = currencyFormatter.stringFromNumber(self.dashboard.total_profit!)
            allTimeButton.titleLabel?.font = UIFont.boldSystemFontOfSize(10.0)
        }
    }
    
    func getDashboard() {
        let client = TSAPI(token: defaults.stringForKey("user.token")!)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        client.getDashboard({responseDictionary in
                self.dashboard = Dashboard(dictionary: responseDictionary["dashboard_stats"]![0] as! NSDictionary)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.getUpdates()
            },
            errorCallback: { dictionary in
                // handle error
        })
    }
    
    func getUpdates(refreshControl: UIRefreshControl? = nil) {
        let client = TSAPI(token: defaults.stringForKey("user.token")!)
        
        client.getOrders({responseDictionary in
            for element in (responseDictionary["orders"]! as! [NSDictionary]) {
                let update = Update(order: Order(dictionary: element))
                
                // TODO: We need UUIDs for updates
                let existingUpdates = self.updates.map{ u in u.createdAt! }
                if let _ = existingUpdates.indexOf(update.createdAt!) {
                } else {
                    self.updates.append(update)
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
        
        self.updates.sortInPlace{$0.createdAt!.compare($1.createdAt!) == NSComparisonResult.OrderedDescending}
    }
    
    func refreshCallback(refreshControl: UIRefreshControl) {
        getUpdates(refreshControl)
    }
    
    func searchPressed(sender: UIView) {
        // go to Designs page
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DashboardViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.updates.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("UpdateCell", forIndexPath: indexPath) as! UpdateCell
        let update = self.updates[indexPath.row]
        cell.messageLabel.text = update.message
        cell.timeAgoLabel.text = update.createdAgo
        
        return cell
    }
}

extension DashboardViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        return nil
    }
}