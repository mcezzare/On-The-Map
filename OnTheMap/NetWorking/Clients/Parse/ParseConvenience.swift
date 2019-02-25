//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 23/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

extension ParseClient {
    func getStudentsLocation(completionHandler: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void){
        //        let params = [ParseClient.ParseMethods.StudentLocation: "-updatedAt" as AnyObject]
        let parseApiHeaders=[
            ParseClient.ParseParameterKeys.APIKey:ParseClient.ParseParametersValues.APIKey,
            ParseClient.ParseParameterKeys.ApplicationID:ParseClient.ParseParametersValues.ApplicationID
        ]
        
        _ = HTTPCLient.shared().taskForGetMethod(
            url: ParseClient.ParseMethods.StudentLocation,
            parameters: [:],
            requestHeaderParameters: parseApiHeaders,
            apiType: .parse,
            completionHandlerForGet: { (data, error) in
                if let error = error {
                    print(error)
                    completionHandler(nil,error)
                } else {
                    if let data = data {
                        self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: { (jsonStringResponse, error) in
                            var studentsLocations = [StudentInformation]()
                            if let results = jsonStringResponse![ParseClient.ParseJSONResponseKeys.Results] as? [[String:AnyObject]]{
                                for location in results{
                                    studentsLocations.append(StudentInformation(location))
                                }
                                completionHandler(studentsLocations,nil)
                                return
                            }
                            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                            completionHandler(studentsLocations,NSError(domain: "getStudentsLocation", code:2, userInfo:userInfo))
                        })
                        
                    }
                }
                
        })
    }
    
    
    
    // MARK: Helpers to decode json responses.Could be done with codable too =(
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
}

