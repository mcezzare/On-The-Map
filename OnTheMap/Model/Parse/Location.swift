//
//  Location.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 03/03/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

/// Codable struct used only to post(create) or put(update) the location of Student.
/// It has the same properties of StudentInformation except for:
/// objectId,createdAt,updatedAt and labelName here named as locationLabel
struct Location: Codable {
    
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
    
    var locationLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        if let lastName = lastName {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        if name.isEmpty {
            name = "No name informed"
        }
        return name
    }
    
}
