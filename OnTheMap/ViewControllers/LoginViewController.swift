//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 12/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController,UITextFieldDelegate,FBSDKLoginButtonDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.makeRoundedCorners()
        signUpButton.makeRoundedCorners()
        initializeFacebookLoogedOf()
        setupFacebookLoginButton()
    }
    
    // MARK: - Actions
    
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
    
    private func authenticateFacebookUser(accessToken: String) {
        UdacityClient.sharedInstance().authenticateFacebookUser(accessToken: accessToken) { (success, errorMessage) in
            if success {
                UdacityClient.sharedInstance().faceBookUser = true
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
    
    // MARK: Send to logged start view
    
    /// Send to logged start view
    private func completeLogin() {
        UdacityClient.sharedInstance().getStudentInfo(completionHandler: { (studentInfo, error) in
            if let error = error {
                self.showInfoAlert(theTitle: "Error" , theMessage: error)
                return
            } else {
                UdacityClient.sharedInstance().udacityUser = studentInfo
                if self.appDelegate.DEBUG{
                    print("DEBUG LOGIN CYCLE")
                    print(studentInfo!)
                }
                
            }
        })
        
        performSegue(withIdentifier: "showMap", sender: nil)
    }
    
    // MARK: - Facebook Methods - Delegates
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            self.showInfoAlert(theTitle: "Erro" ,theMessage: error.localizedDescription)
        } else if result.isCancelled{
            self.showInfoAlert(theTitle: "Erro" ,theMessage: "Usuário cancelou o Login.")
        }else{
            // success
            let ctoken = FBSDKAccessToken.current()
            self.authenticateFacebookUser(accessToken: (ctoken?.tokenString)!)
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out of facebook")
    }
    
    
    private func setupFacebookLoginButton(){
        let btnFBLogin = FBSDKLoginButton()
        btnFBLogin.readPermissions = ["public_profile","email"]
        btnFBLogin.delegate = self
        btnFBLogin.center = self.view.center
        self.view.addSubview(btnFBLogin)
    }
    
    
    /// It looks weird, but how its not possible to go to map view controller directly when
    /// login with facebook , the button logout on login screen looks strange for the user that logged
    /// with the udacity account and log off but the FBSDK is initialized on AppDelegate every time
    private func initializeFacebookLoogedOf(){
        if (FBSDKAccessToken.current() != nil) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            UdacityClient.sharedInstance().faceBookUser = false
        }
    }
    
    // MARK: - Helpers
    
    private func enableUIControls(_ enable: Bool){
        self.enableUIItens(views: emailTextField,passwordTextField,loginButton,signUpButton, enable:enable)
    }
    
}
