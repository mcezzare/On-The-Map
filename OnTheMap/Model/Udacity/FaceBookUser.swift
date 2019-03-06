//
//  FaceBookUser.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 06/03/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

struct FaceBookUser: Codable {
    let facebookMobile: FacebookMobile?
    
    enum CodingKeys: String, CodingKey {
        case facebookMobile = "facebook_mobile"
    }
}

struct FacebookMobile: Codable {
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
