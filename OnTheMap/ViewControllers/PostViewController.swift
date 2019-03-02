//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 16/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit
import CoreLocation

class PostViewController : UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    lazy var geoCoder = CLGeocoder()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findLocationButton.makeRoundedCorners()
        configureNavBar()
    }
    
    // MARK: - Actions
    
    @IBAction func findLocation(_ sender: Any){
        let locationString = locationTextField.text!
        let urlString = urlTextField.text!
        
        if locationString.isEmpty || urlString.isEmpty {
            showInfoAlert(theMessage: "Todos os campos são obrigatórios.")
            return
        }
        
        guard let url = URL(string:urlString), UIApplication.shared.canOpenURL(url) else {
            showInfoAlert(theMessage: "Por favor, informe uma URL válida.")
            return
        }
        
        makeGeoCode(location: locationString)
    }
    
    // MARK: - Functions
    
    private func makeGeoCode(location: String) {
        enableUIControls(false)
        activityIndicator.startAnimating()
        geoCoder.geocodeAddressString(location) { ( placemarkers, error ) in
            
            self.enableUIControls(true)
            
            self.performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                self.showInfoAlert(theTitle: "Erro" , theMessage: "Não foi possível localizar as coordenadas do endereço (\(error)")
            } else {
                
                var location:CLLocation?
                
                if let placemarkers = placemarkers, placemarkers.count > 0 {
                    location = placemarkers.first?.location
                }
                if let location = location{
                    self.saveInformedLocation(location.coordinate)
                } else {
                    self.showInfoAlert(theMessage: "Localização não encontrada.")
                }
            }
            
            
        }
        
    }
    
    
    private func saveInformedLocation( _ coordinate: CLLocationCoordinate2D){
        if appDelegate.DEBUG {
            print("DEBUG: Coordenadas encontradas:\(coordinate)")
        }
        
        
        
    }
    
    // MARK: Configure the navbar
    
    /// Pre-Requisite of project is the back button must have the title "Cancel"
    private func configureNavBar(){
        self.navigationItem.title = "Adicionar localização"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Cancelar"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    // MARK: Call UIViewController Extension to lock UI Itens
    private func enableUIControls(_ enable: Bool){
        self.enableUIItens(views: locationTextField,urlTextField,findLocationButton, enable:enable)
    }
    
}

