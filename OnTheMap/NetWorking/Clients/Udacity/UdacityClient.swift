//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 12/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

/*
 * Constants defined in UdacityConstants.swift
 * Methods defined in UdacityConvenience.swift
 */

/// Client Http to use the Udacity API
class UdacityClient: NSObject {
    
    // MARK: - Properties
    
    var userSession : UserSession!
    var udacityUser : UdacityUser!
    var faceBookUser = false
    
    // MARK: Singleton, Shared Instance
    class func sharedInstance()->UdacityClient{
        struct Singleton{
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
