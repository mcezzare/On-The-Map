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


// MARK: Convenience initializers and mutators
/*
 * Used https://app.quicktype.io/ to skeleton this extension from Json response
 */
extension UserSession {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserSession.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        account: Account? = nil,
        session: Session? = nil
        ) -> UserSession {
        return UserSession(
            account: account ?? self.account,
            session: session ?? self.session
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Account {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Account.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        registered: Bool? = nil,
        key: String? = nil
        ) -> Account {
        return Account(
            registered: registered ?? self.registered,
            key: key ?? self.key
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Session {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Session.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: String? = nil,
        expiration: String? = nil
        ) -> Session {
        return Session(
            id: id ?? self.id,
            expiration: expiration ?? self.expiration
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// To parse the JSON, add this file to your project and do:
//
//   let userSession = try UserSession(json)
//
// To read values from URLs:
//
//   let task = URLSession.shared.userSessionTask(with: url) { userSession, response, error in
//     if let userSession = userSession {
//       ...
//     }
//   }
//   task.resume()
