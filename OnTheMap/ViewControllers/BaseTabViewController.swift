//
//  BaseTabViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 16/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//


import UIKit

class BaseTabViewController : UITabBarController {
    
    // MARK: Outlets
    
    @IBOutlet weak var postLocationButton : UIBarButtonItem!
    @IBOutlet weak var reloadStudentsLocationsButton : UIBarButtonItem!
    @IBOutlet weak var logOutButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

