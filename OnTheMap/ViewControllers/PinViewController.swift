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
    
    
    // MARK: - Functions
    
    
    /// Show the location sent by PostViewController
    private func showStudentLocation(){
        if let studentLocation = studentInformation {
            let location = Location(
                objectId: "",
                uniqueKey: nil,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: "",
                updatedAt: ""
            )
            showLocation(location:location)
        }
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
    
}

