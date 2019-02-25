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
                    // print("Request Worked")
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
                        print("Could not find the logged response itens")
                        completionHandlerForAuth(false, error.localizedDescription)
                    }
                }
        })
    }
    
    // MARK : Get info about Student after login
    func getStudentInfo(completionHandler: @escaping(_ result:UdacityUser?, _ error:String?) -> Void){
        
        let urlPath = UdacityClient.UdacityMethods.Users + "/" + self.userSession.account.key
        
        _ = HTTPCLient.shared().taskForGetMethod(
            url: urlPath,
            parameters: [:],
            completionHandlerForGet: { (data,error) in
                if let error = error {
                    print(error)
                    completionHandler(nil,error.localizedDescription)
                } else {
                    do{
                        let udacityUser = try UdacityUser(data: data!)
                        self.udacityUser = udacityUser
                        completionHandler(udacityUser,nil)
                    }
                    catch{
                        print("Could not read user details")
                        completionHandler(nil, "Could not read user details")
                    }
                }
        }
        )
        
    }
    
    
}
