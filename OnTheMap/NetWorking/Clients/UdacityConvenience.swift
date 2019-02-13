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
        
        //     let jsonBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(userPassword)\"}}" // simple string
        // let jsonBody:String = buildRequestString(userEmail: userEmail, userPassword: userPassword) // generated string
        
        /* Other approach
         */
        
        let credentials = Udacity(username: userEmail, password: userPassword)
        let postData = UdacityRequest(udacity: credentials)
        let encoder = JSONEncoder()
        let jsonBody = try! encoder.encode(postData)
//        let jsonData = String(data:jsonBody, encoding: .utf8)!
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        //        request.httpBody = jsonBody.data(using: .utf8) // simple string -> works
        
//        request.httpBody = jsonBody.data(using: .utf8) // generated string -> works
        request.httpBody = jsonBody
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    private func buildRequestString(userEmail: String, userPassword: String) -> String {
        let credentials = Udacity(username: userEmail, password: userPassword)
        let postData = UdacityRequest(udacity: credentials)
        let encoder = JSONEncoder()
        do{
            let jsonData = try encoder.encode(postData)
            let jsonString = String(data:jsonData, encoding: .utf8)!
            return jsonString
            
        }catch{
            print(error.localizedDescription)
        }
        
        return "[]"
    }
    
   
    
}
