//
//  NotificationsViewController.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 3/20/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "pattern-basic-blue")!
        let uicolor = UIColor(patternImage: image)
        view.backgroundColor = uicolor
    }
    
    @IBAction func enableNotificationsPressed(sender: AnyObject) {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
}
