//
//  MenuViewController.swift
//  Twit
//
//  Created by Lee Edwards on 2/26/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewControllers: [UIViewController] = []
    let titles = ["Dashboard", "Designs", "Notifications"]
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let dashboardVC = storyboard.instantiateViewControllerWithIdentifier("DashboardNavigationController") as! UINavigationController
        let designsVC = storyboard.instantiateViewControllerWithIdentifier("DesignsNavigationController") as! UINavigationController
        let notificationsVC = storyboard.instantiateViewControllerWithIdentifier("NotificationsNavigationController") as! UINavigationController
        
        viewControllers = [dashboardVC, designsVC, notificationsVC]
        
        tableView.backgroundColor = TSColor.lightBlueColor()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutPressed(sender: AnyObject) {
        let loginVC = storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        NSUserDefaults.standardUserDefaults().removeObjectForKey("user.token")
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
}

extension MenuViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}
