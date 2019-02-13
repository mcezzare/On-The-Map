//
//  UserSession.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 13/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

struct UserSession: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id, expiration: String
}

