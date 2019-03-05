//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Mario Cezzare on 23/02/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation

extension ParseClient {
    
    
    /// Get a list of students locations
    ///
    /// - Parameter completionHandler: an array of StudentInformation or an error object
    func getStudentsLocation(completionHandler: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void){
        // Criteria of project, order by updateAt desc
        let queryParameters = [
            ParseClient.ParseParameterKeys.Order:ParseClient.ParseParametersValues.UpdateAtReverseOrder as AnyObject
        ]
        
        _ = HTTPCLient.shared().taskForGetMethod(
            url: ParseClient.ParseMethods.StudentLocation,
            parameters: queryParameters,
            requestHeaderParameters: self.parseApiHeaders,
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
    
    
    /// Register a new location of student
    ///
    /// - Parameters:
    ///   - location: a Location object build on PinViewController
    ///   - completionHandler: escape method to inform if the operation worked
    func  postStudentLocation(location:Location,completionHandler:@escaping(_ success: Bool, _ errorString: String?) -> Void){
        
        // Build json body of request
        /* Can't be done in this way because can't post the field objectId
         * Have to build a string in Json format and don't pass this field
         let encoder = JSONEncoder()
         let jsonBody = try! encoder.encode(location)
         let jsonData = String(data:jsonBody, encoding: .utf8)!
         */
        
        let jsonBody = "{\"uniqueKey\": \"\(location.uniqueKey!)\", \"firstName\": \"\(location.firstName!)\", \"lastName\": \"\(location.lastName!)\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL!)\",\"latitude\": \(location.latitude!), \"longitude\": \(location.longitude!)}"
        
        
        //        print(jsonBody)
        
        let urlPath = ParseClient.ParseMethods.StudentLocation
        
        _ = HTTPCLient.shared().taskForPostMethod(
            url: urlPath,
            jsonBody: jsonBody,
            parameters: [:],
            requestHeaderParameters: self.parseApiHeaders,
            apiType: HTTPCLient.APIType.parse,
            completionHandlerForPost: { (data, error) in
                if let error = error {
                    print(error)
                    completionHandler(false,error.localizedDescription)
                } else {
                    // Parse the response
                    do{
                        let location = try Location(data:data!)
                        if (location.objectID != nil) {
                            self.currentRegisteredLocation = location
                            completionHandler(true,nil)
                        }else {
                            self.currentRegisteredLocation = nil
                            completionHandler(false,"Não foi possível registrar a localização.")
                        }
                    }
                    catch{
                        print("Houve um erro ao gravar os dados de localização.")
                        completionHandler(false,"Houve um erro ao gravar os dados de localização.")
                    }
                }
        })
        
    }
    
    // MARK: Helpers to decode json responses.Could be done with codable too =(
    
    /// Function to parse Response data of requests
    ///
    /// - Parameters:
    ///   - data: normally json response of APIs
    ///   - completionHandlerForConvertData: a data with json format or an error
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

