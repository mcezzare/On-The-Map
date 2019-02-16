//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 12/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

extension UdacityClient {
    func authenticateUser(userEmail: String, userPassword: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // Build Json body of request
        let credentials = Udacity(username: userEmail, password: userPassword)
        let postData = UdacityRequest(udacity: credentials)
        let encoder = JSONEncoder()
        let jsonBody = try! encoder.encode(postData)
        let jsonData = String(data:jsonBody, encoding: .utf8)!
        let urlPath = UdacityClient.UdacityMethods.Authentication
        
        _ = HTTPCLient.shared().taskForPostMethod(
            url:urlPath,
            jsonBody:jsonData,
            parameters: [:],
            apiType: HTTPCLient.APIType.udacity,
            completionHandlerForPost: { (data, error) in
                if let error = error {
                    print(error)
                    completionHandlerForAuth(false, error.localizedDescription)
                } else {
                    
                    // work on data result
                    print("Request Worked")
                    do {
                        let userSession = try UserSession(data: data!)
                        if !userSession.account.registered {
                            completionHandlerForAuth(false, "Login Failed, user not registered.")
                        }else {
                            self.userSession = userSession
                            completionHandlerForAuth(true, nil)
                        }
                    }
                    catch {
                        // what kind of error can happen here ?
                        print("Could not find the looged response itens")
                        completionHandlerForAuth(false, error.localizedDescription)
                    }
                }
        })
    }
    
    
}
