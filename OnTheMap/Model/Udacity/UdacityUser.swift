//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 12/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

struct UdacityUser {
    var key: String
    var firstName: String
    var lastName: String
    var imageUrl: String
    
    init(dictionary: [String:AnyObject]){
        self.key = dictionary[UdacityClient.JSONResponseKeys.Key] as!String
        self.firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as!String
        self.lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as!String
        self.imageUrl = dictionary[UdacityClient.JSONResponseKeys.ImageUrl] as!String
    }
    
}
