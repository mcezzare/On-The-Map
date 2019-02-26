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

class ParseClient: NSObject {
    
    // MARK: Properties
//    var studentsLocation : StudentsLocation!
    
    // MARK: Singleton, Shared Instance
    class func sharedInstance()->ParseClient{
        struct Singleton{
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
