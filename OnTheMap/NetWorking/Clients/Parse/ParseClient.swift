//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 18/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

/*
 * Constants defined in ParseConstants.swift
 * Methods defined in ParseConvenience.swift
 */


/// Client Http to use the Parse API
class ParseClient: NSObject {
    
    // MARK: -  Properties
    
    // MARK: Will be filed after user post a new location
    var locationIdPosted = false
    var currentRegisteredLocation : Location!
    
    // MARK: Authentication Headers for this service
    let parseApiHeaders = [
        ParseClient.ParseParameterKeys.APIKey:ParseClient.ParseParametersValues.APIKey,
        ParseClient.ParseParameterKeys.ApplicationID:ParseClient.ParseParametersValues.ApplicationID
    ]
    
    // MARK: Singleton, Shared Instance
    class func sharedInstance()->ParseClient{
        struct Singleton{
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
