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
        NotificationCenter.default.addObserver(self, selector: #selector(loadStudentsInformation), name: .reload ,  object: nil)
        loadStudentsInformation()
    }
    
    // MARK: Remove Observers
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Actions
    @IBAction func reload(_ sender: Any){
        loadStudentsInformation()
    }
    
    // MARK : Load students locations from Parse API
    @objc private func loadStudentsInformation(){
        NotificationCenter.default.post(name: .reloadStarted, object: nil)
        ParseClient.sharedInstance().getStudentsLocation(){ (studentsLocation, errorMessage) in
            if errorMessage != nil {
                print(errorMessage?.localizedDescription)
            } else {
                print("From  basetabviewcontroller \(studentsLocation)")
            }
        }
    }
    
}

