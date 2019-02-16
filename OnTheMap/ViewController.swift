//
//  ViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 06/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var textView: UITextView!
    
    // MARK: Properties
    var userSession:UserSession!
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Just to make a test if the Looged user is arriving here
    func initialize(){
        var tempText:String!
        
        if self.userSession == nil {
            self.userSession = UdacityClient.sharedInstance().userSession
        }
        
        do{
            tempText = try self.userSession.jsonString()
        }
        catch{
            tempText = "Unknow user logged in"
        }
        
        performUIUpdatesOnMain(
            { self.textView.text = tempText }
        )
    }
}

