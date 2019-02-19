//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 18/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

/*
 * Constants defined in UdacityConstants.swift
 * Methods defined in UdacityConvenience.swift
 */

class ParseClient: NSObject {
    
    // MARK: Properties
    
    
    // MARK: Singleton, Shared Instance
    class func sharedInstance()->ParseClient{
        struct Singleton{
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
