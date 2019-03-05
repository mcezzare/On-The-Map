//
//  Location.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 03/03/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

/// Codable struct used only to post(create) or put(update) the location of Student.
/// It has the same properties of StudentInformation except for:
/// objectId,createdAt,updatedAt and labelName here named as locationLabel

struct Location: Codable {
    let objectID, uniqueKey, firstName, lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude, longitude: Double?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case objectID = "objectId"
        case uniqueKey, firstName, lastName, mapString, mediaURL, latitude, longitude, createdAt, updatedAt
    }
    
    var locationLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        if let lastName = lastName {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        if name.isEmpty {
            name = "No name informed"
        }
        return name
    }
}

// MARK: Convenience initializers and mutators

extension Location {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Location.self, from: data)
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
        objectID: String?? = nil,
        uniqueKey: String?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        mapString: String?? = nil,
        mediaURL: String?? = nil,
        latitude: Double?? = nil,
        longitude: Double?? = nil,
        createdAt: String?? = nil,
        updatedAt: String?? = nil
    ) -> Location {
        return Location(
            objectID: objectID ?? self.objectID,
            uniqueKey: uniqueKey ?? self.uniqueKey,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            mapString: mapString ?? self.mapString,
            mediaURL: mediaURL ?? self.mediaURL,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt
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

/*struct Location: Codable {
    
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String?
    
    var locationLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        if let lastName = lastName {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        if name.isEmpty {
            name = "No name informed"
        }
        return name
    }
    
}
*/

