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
        
        //        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        //        request.httpMethod = "POST"
        //        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.httpBody = jsonBody
        
        //        let session = URLSession.shared
        //        let task = session.dataTask(with: request) { data, response, error in
        //            if error != nil { // Handle error…
        //                completionHandlerForAuth(false,error?.localizedDescription)
        //                //                return
        //            } else {
        //                let range = Range(5..<data!.count)
        //                let newData = data?.subdata(in: range) /* subset response data! */
        //                print(String(data: newData!, encoding: .utf8)!)
        //                completionHandlerForAuth(true,nil)
        //            }
        //
        //        }
        //        task.resume()
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
                    print(data)
                    completionHandlerForAuth(true, nil)
                }
                
        })
    }
    

    
    
}
