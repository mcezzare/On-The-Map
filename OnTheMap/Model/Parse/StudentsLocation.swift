//
//  StudentsLocation.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 24/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

struct StudentsLocation {
    
    static var shared = StudentsLocation()
    
    // Required
    private init(){}
    
    var studentsInformation = [StudentInformation]()
}
