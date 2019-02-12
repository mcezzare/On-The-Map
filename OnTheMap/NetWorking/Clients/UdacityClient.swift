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
 */

class UdacityClient: NSObject {
    
    // MARK: Properties
    var userData: UdacityUser!
    var userKey: String? = nil
    
    // MARK: Singleton, Shared Instance
    class func sharedInstance()->UdacityClient{
        struct Singleton{
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
