//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 16/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController : BaseMapViewController {
    
    // MARK : Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapView")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        mapView.delegate = self
//        loadUserInfo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Helpers
    
    @objc func reloadStarted() {
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
            self.mapView.alpha = 0.5
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.activityIndicator.stopAnimating()
            self.mapView.alpha = 1
            self.showStudentsInformation(StudentsLocation.shared.studentsInformation)
        }
    }
    
    // MARK: Get students location already loaded in shared struct instance
    private func showStudentsInformation(_ studentsInformation: [StudentInformation]) {
        mapView.removeAnnotations(mapView.annotations)
        for info in studentsInformation where info.latitude != 0 && info.longitude != 0 {
            let annotation = MKPointAnnotation()
            annotation.title = info.labelName
            annotation.subtitle = info.mediaURL
            annotation.coordinate = CLLocationCoordinate2DMake(info.latitude, info.longitude)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    
}
