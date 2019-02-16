//
//  HTTPClient.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 16/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation
import UIKit

class HTTPCLient : NSObject {
    // MARK : Properties
    
    // MARK :
    var session = URLSession.shared
    
    // authentication state
    var sessionID: String? = nil
    var userKey = ""
    var userName = ""
    
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    
    class func shared() -> HTTPCLient {
        struct Singleton {
            static var shared = HTTPCLient()
        }
        return Singleton.shared
    }
    
    func taskForPostMethod(
        url urlPath           : String,
        jsonBody                : String,
        parameters               : [String:AnyObject],
        //        headers httpHeaders     : [String:String]?,
        apiType                 : APIType = .udacity,
        completionHandlerForPost: @escaping (_ result: Data?, _ error: NSError?) -> Void ) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        let urlString = self.buildURLFromParameters(parameters,withPathExtension:urlPath,apiType: apiType)
        
        /* 2/3. Build the URL, Configure the request */
        var request = NSMutableURLRequest(url: urlString)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request  as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPost(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Request did not return a valid response.")
                return
            }
            
            switch (statusCode) {
            case 403:
                sendError("Please check your credentials and try again.")
            case 200 ..< 299:
                break
            default:
                sendError("Your request returned a status code other than 2xx!")
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // skipping the first 5 characters for Udacity API calls
            var newData = data
            if apiType == .udacity {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range) /* subset response data! */
            }
            
            print(String(data: newData, encoding: .utf8)!)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForPost(newData,nil)
            
        }
        
        task.resume()
        
        return task
        
    }
    
    
    // MARK: - Apis used in this project
    
    enum APIType {
        case udacity
        case parse
    }
    
    // create a URL from parameters
    private func buildURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil, apiType: APIType = .udacity) -> URL {
        
        var components = URLComponents()
        components.scheme = apiType == .udacity ? UdacityClient.UdacityService.APIScheme : "" // Constants.Parse.APIScheme
        components.host = apiType == .udacity ? UdacityClient.UdacityService.APIHost : "" // Constants.Parse.APIHost
        components.path = (apiType == .udacity ? UdacityClient.UdacityService.APIPath : "" /*Constants.Parse.APIPath*/) + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
 
   
    // MARK : Helpers
    //        func sendError(_ error: String) {
    //            print(error)
    //            let userInfo = [NSLocalizedDescriptionKey : error]
    //            completionHandlerForPost(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
    //        }
    
}
