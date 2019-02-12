//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 12/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.makeRoundedCorners()
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        activityIndicator.startAnimating()
        enableUIControls(false)
        
        
    }
    
    
    
    // MARK: Call UIViewController Extension to lock UI Itens
    private func enableUIControls(_ enable: Bool){
        self.enableUIItens(views: emailTextField,passwordTextField,loginButton,signUpButton, enable:enable)
    }
}
