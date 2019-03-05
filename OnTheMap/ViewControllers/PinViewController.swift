//
//  PinViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 16/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// Identified in StoryBoard by `PinLocationView`
class PinViewController : BaseMapViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishPostLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    var studentInformation: StudentInformation?
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishPostLocationButton.makeRoundedCorners()
        mapView.delegate = self
        showStudentLocation()
    }
    
    // MARK: - Actions
    
    @IBAction func finishPostLocationButtonPressed(){
        activityIndicator.startAnimating()
        enableUIControls(false)
        
        guard let location = buildLocationFromStudentInformation(studentInformation: self.studentInformation) else {
            activityIndicator.stopAnimating()
            enableUIControls(true)
            
            showInfoAlert(theTitle: "Erro", theMessage: "Não é possível usar a localização informada.")
            return
        }
        
        ParseClient.sharedInstance().postStudentLocation(location:location){ (success,errorMesage) in
            if success {
                self.showInfoAlert(theTitle: "Sucesso", theMessage: "Localização atualizada", action: {
                    self.navigationController?.popToRootViewController(animated: true)
                    NotificationCenter.default.post(name: .reload, object:nil)
                })
            } else {
                self.performUIUpdatesOnMain {
                    self.showInfoAlert(theTitle: "Erro", theMessage: errorMesage!)
                }
            }
            self.performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.enableUIControls(true)
            }
            
        }
    }
    
    
    // MARK: - Functions
    
    
    /// Show the location sent by PostViewController
    private func showStudentLocation(){
        let location = buildLocationFromStudentInformation(studentInformation: self.studentInformation)
        showLocation(location:location!)
    }
    
    // MARK: - Helpers
    
    /// Draw on the mapView the location informed by the student
    ///
    /// - Parameter location: Location The new coordinates of student
    private func showLocation(location: Location){
        mapView.removeAnnotations(mapView.annotations)
        if let coordinates = buildCLLocationCoordinate2D(location:location){
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinates
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
        
    }
    
    
    /// Build a CLLocationCoordinate2D extracting data from a Location Object
    ///
    /// - Parameter location: Location object from StudentInformation Object
    /// - Returns: a CLLocationCoordinate2D to draw a point on Map
    private func buildCLLocationCoordinate2D(location: Location) -> CLLocationCoordinate2D? {
        if let latitude = location.latitude, let longitude = location.longitude {
            return CLLocationCoordinate2D(latitude: latitude,longitude: longitude)
        }
        return nil
    }
    
    
    /// Build a Location object based on a StudentIformation struct
    ///
    /// - Parameter studentInformation: StudentInformation created with Address String created on PostViewController
    /// - Returns: a Location Object
    func buildLocationFromStudentInformation(studentInformation : StudentInformation?) -> Location? {
        if let studentLocation = studentInformation {
            let location = Location(
                objectID: "",
                uniqueKey: UdacityClient.sharedInstance().udacityUser.key,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: "",
                updatedAt: ""
            )
            return location
        }
        
        return nil
        
    }
    
    // MARK: Call UIViewController Extension to lock UI Itens
    private func enableUIControls(_ enable: Bool){
        self.enableUIItens(views: finishPostLocationButton, enable:enable)
        //        enable == true ? self.mapView.alpha = 1 : self.mapView.alpha = 0.5 // don't work in this way
        if enable {
            self.mapView.alpha = 1
        } else {
            self.mapView.alpha = 0.5
        }
        
    }
    
    
}

