//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 23/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

/// Struct used to keep information of Student on Parse Service
struct StudentInformation {
    
    let locationID: String?
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    init(_ dictionary: [String: AnyObject]) {
        self.locationID = dictionary["objectId"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
    }
    
    // MARK:  Reserved attribute to use in case of the name of Student is empty
    var labelName: String {
        var name = ""
        if !firstName.isEmpty {
            name = firstName
        }
        if !lastName.isEmpty {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        if name.isEmpty {
            name = "No name provided"
        }
        return name
    }
    
}
