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
                    completionHandler(nil,error)
                } else
                    if let data = data{
                        print(data)
                }
        })
        
    }
}

