//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 16/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit

class PostViewController : UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findLocationButton.makeRoundedCorners()
        configureNavBar()
    }
    
    // MARK: - Configure the navbar
    
    
    /// Pre-Requisite of project is the back button must have the title "Cancel"
    private func configureNavBar(){
        self.navigationItem.title = "Adicionar localização"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Cancelar"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    
}

