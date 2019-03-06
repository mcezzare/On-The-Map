//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 18/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct ParseService {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse"
        /* I had to do it because the parse API was broken at Mon Mar  4 23:32:01 -03 2019, and I had to setup a local Parse Server */
        //        static let APIScheme = "http"
        //        static let APIHost = "192.168.15.21"
        //        static let APIPath = "/parse"
        //        static let APIPort = 1337
        
    }
    
    struct ParseMethods {
        static let StudentLocation = "/classes/StudentLocation"
    }
    
    // Will be replaced by codable structs, if possible
    struct ParseJSONResponseKeys {
        static let Results = "results"
    }
    
    struct ParseParameterKeys {
        static let APIKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let Where = "where"
        static let Order = "order"
    }
    
    struct ParseParametersValues {
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let UpdateAtReverseOrder="-updatedAt"
    }
    
}
