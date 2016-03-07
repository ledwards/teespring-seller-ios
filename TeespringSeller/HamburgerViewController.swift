//
//  HamburgerViewController.swift
//  Twit
//
//  Created by Lee Edwards on 2/28/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    var menuViewController: MenuViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            closeMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(sender: AnyObject) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == .Began {
            self.originalLeftMargin = self.leftMarginConstraint.constant
        } else if sender.state == .Changed {
            self.leftMarginConstraint.constant = self.originalLeftMargin + translation.x
        } else if sender.state == .Ended {
            if velocity.x > 0 {
                openMenu()
            } else {
                closeMenu()
            }
        }
    }
    
    func openMenu() {
        UIView.animateWithDuration(0.3, animations: {
            self.leftMarginConstraint.constant = self.view.frame.size.width - 50
            self.view.layoutIfNeeded()
        })
    }
    
    func closeMenu() {
        UIView.animateWithDuration(0.3, animations: {
            self.leftMarginConstraint.constant = CGFloat(0.0)
            self.view.layoutIfNeeded()
        })
    }
    
}
