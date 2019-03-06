//
//  BaseTabViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 16/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

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
    
    // MARK: - Actions
    @IBAction func reload(_ sender: Any){
        loadStudentsInformation()
    }
    
    // MARK : Load students locations from Parse API
    @objc private func loadStudentsInformation(){
        NotificationCenter.default.post(name: .reloadStarted, object: nil)
        ParseClient.sharedInstance().getStudentsLocation(){ (studentsLocation, error) in
            if let error = error {
                self.showInfoAlert(theTitle: "Erro" , theMessage: error.localizedDescription)
                NotificationCenter.default.post(name: .reloadCompleted , object: nil)
                return
            }
            if let studentsLocation = studentsLocation {
                StudentsLocation.shared.studentsInformation = studentsLocation
            }
            NotificationCenter.default.post(name: .reloadCompleted , object: nil)
            // Show must go on on MapViewController
        }
    }
    
    
    /// LogOff the current user, destroy the session and go to the login screen
    ///
    /// - Parameter sender: the Logout button
    @IBAction func logout(_ sender: Any){
        if UdacityClient.sharedInstance().faceBookUser {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            UdacityClient.sharedInstance().faceBookUser = false
        }
        
        UdacityClient.sharedInstance().logout(){ (success,error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showInfoAlert(theTitle: "Erro" , theMessage: error!.localizedDescription)
            }
            
        }
    }
    
    @IBAction func postLocationButtonPressed(_ sender: Any){
        self.enableUIControls(false)
        
        if ParseClient.sharedInstance().locationIdPosted  {
            let confirmMsg = "Você já informou sua localização anteriormente. Deseja atualizar sua nova localização?"
            self.showConfirmationAlert(withMessage: confirmMsg, actionTitle: "Reescrever", action: {
                self.showPostingView()
            })
        } else {
            self.showPostingView()
            
        }
        
        self.enableUIControls(true)
        
    }
    
    //MARK: - Segues
    
    private func showPostingView(){
        let viewController = storyboard?.instantiateViewController(withIdentifier: "PostLocationView") as! PostViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - Helpers
    
    private func enableUIControls(_ enable: Bool) {
        performUIUpdatesOnMain {
            self.postLocationButton.isEnabled = enable
            self.reloadStudentsLocationsButton.isEnabled = enable
            self.logOutButton.isEnabled = enable
        }
    }
    
  

}

