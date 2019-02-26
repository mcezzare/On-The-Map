//
//  BaseMapViewController.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 25/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

import UIKit
import MapKit
import CoreLocation

class BaseMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else  {
                self.showInfoAlert(theMessage: "SubTitulo não informado")
                return
            }
            guard let link = subtitle else {
                self.showInfoAlert(theMessage: "Link não informado")
                return
            }
            openWithSafari(link)
        }
    }
    
}
