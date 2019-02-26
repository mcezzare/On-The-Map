//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 12/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct UdacityService {
        static let APIScheme = "https"
        static let APIHost = "onthemap-api.udacity.com"
        static let APIPath = "/v1"
    }
    
    struct UdacityMethods {
        static let Authentication = "/session"
        static let Users = "/users"
    }

    
// will be replaced by codable structs
//    struct JSONResponseKeys{
//        static let Key = "key"
//        static let LastName = "last_name"
//        static let FirstName = "first_name"
//        static let ImageUrl = "_image_url"
//    }
//    
    
}
