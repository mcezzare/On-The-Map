//
//  UdacityRequest.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 13/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

// MARK: Structs used for login the user

struct UdacityRequest: Codable {
    let udacity: Udacity
}

struct Udacity: Codable {
    let username, password: String
}
