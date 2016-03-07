//
//  LoginViewController.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 3/5/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBAction func onPressLogin(sender: AnyObject) {
        getLoginToken(emailField.text!, password: passwordField.text!)
    }

    let defaults = NSUserDefaults.standardUserDefaults()
    var delegate: DashboardViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = TSColor.lightBlueColor()
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.layer.cornerRadius = 3
    }
    
    // TODO: This animation sucks, should bypass login entirely when logged in
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = defaults.valueForKey("user.token") {
            self.login()
        }
    }

    func getLoginToken(email: String, password: String) {
        let client = TSAPI()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        client.getAccessToken(email, password: password,
            successCallback: { dictionary in
                let token = dictionary["token"] as! String
                self.defaults.setValue(token, forKey: "user.token")
                self.defaults.synchronize()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.login()
            },
            errorCallback: { error in
                // handle error
                print("Login error: \(error!)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        let hamburgerVC = storyboard.instantiateViewControllerWithIdentifier("HamburgerViewController") as! HamburgerViewController
        let dashboardVC = storyboard.instantiateViewControllerWithIdentifier("DashboardNavigationController") as! UINavigationController
        
        menuVC.hamburgerViewController = hamburgerVC
        hamburgerVC.menuViewController = menuVC
        hamburgerVC.contentViewController = dashboardVC
        self.delegate = dashboardVC.topViewController as? DashboardViewController
        self.delegate!.getDashboard()
        
        self.presentViewController(hamburgerVC, animated: true, completion: nil)
        
    }

}
