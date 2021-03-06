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
    
    // MARK: - Properties
    
    var session = URLSession.shared
    
    // MARK : Access the debug on delegate property, used to debug the App and see requests and responses
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
    // MARK: - Request Methods
    
    // MARK: POST or PUT
    
    /// Method to make post or put http requests
    ///
    /// - Parameters:
    ///   - urlPath: url of request
    ///   - jsonBody: json body of the request
    ///   - parameters: main method of rest api and any additional parameters to use on QueryString
    ///   - httpHeaders: additional headers, auth, content-type, etc.
    ///   - apiType: which api to use for the request
    ///   - methodHttp: verb http to use POST or PUT
    ///   - completionHandlerForPost: the escaping function returns **Data** in case it succeeds or **NSError** in case of failure.
    /// - Returns: URLSessionDataTask
    func taskForPostOrPutMethod(
        url urlPath                         : String,
        jsonBody                            : String,
        parameters                          : [String:AnyObject],
        requestHeaderParameters httpHeaders : [String:String]? = nil,
        apiType                             : APIType = .udacity,
        methodHttp                          : HTTPMethod? = .post,
        completionHandlerForPost            : @escaping (_ result: Data?, _ error: NSError?) -> Void ) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        let urlString = self.buildURLFromParameters(parameters,withPathExtension:urlPath,apiType: apiType)
        
        
        /* 2/3. Build the URL, Configure the request */
        var request = NSMutableURLRequest(url: urlString)
        request.httpMethod = (methodHttp?.getVerb())!
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        
        if let headersParam = httpHeaders {
            for (key,value) in httpHeaders! {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        if self.appDelegate.DEBUG {
            print("DEBUG \(String(describing: methodHttp?.getVerb())) INFO HEADERS")
            print(request.allHTTPHeaderFields!)
            print("DEBUG \(String(describing: methodHttp?.getVerb())) INFO QUERYSTRING")
            print(request)
        }
        
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
            
            // Skipping the first 5 characters for Udacity API calls
            var newData = data
            if apiType == .udacity {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range) /* subset response data! */
            }
            
            if self.appDelegate.DEBUG {
                print("DEBUG: RETURN DATA->")
                print(String(data: newData, encoding: .utf8)!)
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForPost(newData,nil)
            
        }
        
        task.resume()
        
        return task
        
    }
    
    // MARK: GET
    
    /// Method to make get http requests
    ///
    /// - Parameters:
    ///   - urlPath: url of request
    ///   - parameters: main method of rest api and any additional parameters to use on QueryString
    ///   - httpHeaders: additional headers, auth, content-type, etc.
    ///   - apiType: which api to use for the request
    ///   - methodHttp: verb http to use GET
    ///   - completionHandlerForGet: the escaping function returns **Data** in case it succeeds or **NSError** in case of failure.
    /// - Returns: <#return value description#>
    func taskForGetMethod(
        url urlPath                         : String,
        parameters                          : [String:AnyObject],
        requestHeaderParameters httpHeaders : [String:String]? = nil,
        apiType                             : APIType = .udacity,
        methodHttp                          : HTTPMethod? = .get,
        completionHandlerForGet            : @escaping (_ result: Data?, _ error: NSError?) -> Void ) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        let urlString = self.buildURLFromParameters(parameters,withPathExtension:urlPath,apiType: apiType)
        
        
        /* 2/3. Build the URL, Configure the request */
        var request = NSMutableURLRequest(url: urlString)
        request.httpMethod = (methodHttp?.getVerb())!
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headersParam = httpHeaders {
            for (key,value) in httpHeaders! {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        if self.appDelegate.DEBUG {
            print("DEBUG GET INFO HEADERS")
            print(request.allHTTPHeaderFields!)
            print("DEBUG GET INFO QUERYSTRING")
            print(request)
        }
        
        /* 4. Make the request */
        let task = session.dataTask(with: request  as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGet(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
            
            // Skipping the first 5 characters for Udacity API calls
            var newData = data
            if apiType == .udacity {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range) /* subset response data! */
            }
            
            if self.appDelegate.DEBUG {
                print("DEBUG INFO")
                print(String(data: newData, encoding: .utf8)!)
            }
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForGet(newData,nil)
            
        }
        
        task.resume()
        
        return task
        
    }
    
    // MARK: DELETE
    
    /// Method to make delete requests
    ///
    /// - Parameters:
    ///   - urlPath: url of request
    ///   - parameters: main method of rest api and any additional parameters to use on QueryString
    ///   - apiType: which api to use for the request
    ///   - methodHttp: verb http to use POST or PUT
    ///   - completionHandlerForDelete: the escaping function returns **Data** in case it succeeds or **NSError** in case of failure.
    /// - Returns: URLSessionDataTask
    func taskForDeleteMethod(
        _ urlPath                   : String,
        parameters                 : [String:AnyObject],
        apiType                    : APIType = .udacity,
        methodHttp                 : HTTPMethod? = .delete,
        completionHandlerForDelete : @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: buildURLFromParameters(parameters, withPathExtension: urlPath, apiType: apiType))
        request.httpMethod = (methodHttp?.getVerb())!
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        showActivityIndicator(true)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                self.showActivityIndicator(false)
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDelete(nil, NSError(domain: "taskForDeleteMethod", code: 1, userInfo: userInfo))
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
                newData = data.subdata(in: range)
            }
            
            self.showActivityIndicator(false)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForDelete(newData, nil)
            
        }
        task.resume()
        return task
    }
    
    
    // MARK: - Apis used in this project
    
    enum APIType {
        case udacity
        case parse
    }
    
    // MARK: - Methods used in HTTP Requests
    
    enum HTTPMethod {
        case get,post,put,delete
        func getVerb() -> String {
            switch self{
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .delete:
                return "DELETE"
            }
        }
    }
    
    // MARK: - Helpers
    
    /// Create a URL from parameters
    ///
    /// - Parameters:
    ///   - parameters: main method of rest api and any additional parameters to use on QueryString
    ///   - withPathExtension: params of QueryString
    ///   - apiType: which api to use for the request
    /// - Returns: a ready to use and valid URL
    private func buildURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil, apiType: APIType = .udacity) -> URL {
        
        var components = URLComponents()
        components.scheme = apiType == .udacity ? UdacityClient.UdacityService.APIScheme : ParseClient.ParseService.APIScheme
        components.host = apiType == .udacity ? UdacityClient.UdacityService.APIHost : ParseClient.ParseService.APIHost
        components.path = (apiType == .udacity ? UdacityClient.UdacityService.APIPath : ParseClient.ParseService.APIPath) + (withPathExtension ?? "")
        // I had to do configure a alternative port because the parse API was broken, and I had to setup a local Parse Server
        //        if apiType == .parse {
        //                components.port = ParseClient.ParseService.APIPort
        //        }
        
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    /// Show or Hide Network activity indicator.
    ///
    /// - Parameter show: use either **true** to show or **false** to hide it
    private func showActivityIndicator(_ show: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = show
        }
    }
    
    
}
