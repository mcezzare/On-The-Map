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
        signUpButton.makeRoundedCorners()
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        activityIndicator.startAnimating()
        enableUIControls(false)
        
        guard let email = emailTextField.text, !email.isEmpty else {
            activityIndicator.stopAnimating()
            enableUIControls(true)
            showInfoAlert(theTitle: "Campo obrigatório" , theMessage: "Preencha o campo email." )
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            activityIndicator.stopAnimating()
            enableUIControls(true)
            showInfoAlert(theTitle: "Campo obrigatório" , theMessage: "Preencha o campo senha." )
            return
        }
        
        self.authenticateUdacityUser(email: email, password: password)
    }
    
    /// Send guest to SignUP webSite
    @IBAction func signUpButtonPressed( sender: AnyObject){
        openWithSafari(Constants.UdacityUrlSignUp)
    }
    
    // MARK:- Functions
    
    private func authenticateUdacityUser(email: String, password: String){
        UdacityClient.sharedInstance().authenticateUser(userEmail: email, userPassword: password) { (success, errorMessage) in
            if success {
                self.completeLogin()
            } else {
                self.performUIUpdatesOnMain {
                    self.showInfoAlert(theTitle: "Login falhou", theMessage: "Tente com outras credenciais.")
                }
            }
            self.performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.enableUIControls(true)
            }
            
        }
    }
    
    // MARK: Call UIViewController Extension to lock UI Itens
    private func enableUIControls(_ enable: Bool){
        self.enableUIItens(views: emailTextField,passwordTextField,loginButton,signUpButton, enable:enable)
    }
    
    // MARK: Send to logged start view
    
    /// Send to logged start view
    private func completeLogin() {
        
        UdacityClient.sharedInstance().getStudentInfo(completionHandler: { (studentInfo, error) in
            if let error = error {
                self.showInfoAlert(theTitle: "Error" , theMessage: error)
                return
            } else {
                print(studentInfo) // TODO: something
            }
        })
        
        performSegue(withIdentifier: "showMap", sender: nil)
        /*
         When debugging to check if Logged User is stored on shared instance of UdacityClient, will be removed
         let navigationManagerController = storyboard!.instantiateViewController(withIdentifier: "secondViewController")
         self.present(navigationManagerController, animated: true, completion: nil)
         */
    }
    
}
