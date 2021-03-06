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
    
    // MARK : Access the debug on delegate property, used to debug the App and see requests and responses
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life Cycle
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
    
    
    /// Save the coordinates translated by address string and call buildStudentIformation to send to pinLocationView
    ///
    /// - Parameter coordinate: translated coordinates
    private func saveInformedLocation( _ coordinate: CLLocationCoordinate2D){
        if appDelegate.DEBUG {
            print("DEBUG: Coordenadas encontradas:\(coordinate)")
        }
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "PinLocationView") as! PinViewController
        viewController.studentInformation = self.buildStudentInformation(coordinate)
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    /// Prepare a StudentInformation to Post with the new location to PARSE API
    ///
    /// - Parameter coordinate: CLLocationCoordinate2D the new coordinates
    /// - Returns: StudentInformation object
    private func buildStudentInformation(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        let udacityUser = UdacityClient.sharedInstance().udacityUser
        
        
        // Lets supose the user don't have any location saved yet
        let studentInfoBuilder = [
            "uniqueKey" : udacityUser?.key as Any, // It will always have this value in this point
            "firstName": udacityUser?.firstName ?? "",
            "lastName": udacityUser?.lastName ?? "",
            "mapString": locationTextField.text!,
            "mediaURL": urlTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        return StudentInformation(studentInfoBuilder)
        
    }
    
    // MARK: - Helpers
    
    // MARK: Configure the navbar
    
    /// Pre-Requisite of project is the back button must have the title "Cancel"
    private func configureNavBar(){
        performUIUpdatesOnMain {
            self.navigationItem.title = "Adicionar localização"
            let backButton = UIBarButtonItem()
            backButton.title = "Cancelar"
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        }
    }
    
    
    // MARK: Call UIViewController Extension to lock UI Itens
    private func enableUIControls(_ enable: Bool){
        self.enableUIItens(views: locationTextField,urlTextField,findLocationButton, enable:enable)
    }
    
}

