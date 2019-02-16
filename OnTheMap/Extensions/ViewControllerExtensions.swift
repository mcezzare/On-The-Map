//
//  ViewControllerExtensions.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 12/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: Lock or Unlock UI Itens when do background tasks
    func enableUIItens(views:UIControl...,enable:Bool){
        for view in views{
            view.isEnabled = enable
        }
    }
    
    
    // MARK: use GCD to back to main thread and update screen
    func performUIUpdatesOnMain(_ updatesOnScreen: @escaping() -> Void){
        DispatchQueue.main.async {
            updatesOnScreen()
        }
    }
    
    // MARK: Show alert dialog
    func showInfoAlert(theTitle: String = "Info", theMessage: String, action: (() -> Void)? = nil) {
        performUIUpdatesOnMain {
            let alertViewControler = UIAlertController(title: theTitle, message: theMessage, preferredStyle: .alert)
            alertViewControler.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(alertViewControler, animated: true, completion: nil)
        }
    }
    
    
    
}
