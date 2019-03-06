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
        
        _ = HTTPCLient.shared().taskForPostOrPutMethod(
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
                            completionHandlerForAuth(false, "Login falhou, usuário não registrado.")
                        }else {
                            self.userSession = userSession
                            completionHandlerForAuth(true, nil)
                        }
                    }
                    catch {
                        // what kind of error can happen here ?
                        print("Não foi possível encontrar os dados de Usuário.")
                        completionHandlerForAuth(false, error.localizedDescription)
                    }
                }
        })
    }
    
    
    /// Logout the current user and destroy the session based on Cookie from Login
    ///
    /// - Parameter completionHandlerForLogout: return **true** if works and **false** on fail and describes the error
    func logout(completionHandlerForLogout: @escaping (_ success: Bool, _ error: Error?) -> Void){
        let urlPath = UdacityClient.UdacityMethods.Authentication
        _ = HTTPCLient.shared().taskForDeleteMethod(
            urlPath,
            parameters: [:],
            completionHandlerForDelete:{ (data,error) in
                if let error = error {
                    print(error)
                    completionHandlerForLogout(false,error)
                } else {
                    
                    let sessionData = self.parseSession(data: data)
                    print(sessionData)
                    if let _ = sessionData.0 {
                        self.userSession = nil
                        completionHandlerForLogout(true, nil)
                    } else {
                        completionHandlerForLogout(false, sessionData.1!)
                    }
                }
                
        }
        )
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
    
    
    
    /// Prepare data from user Session. Used only to logout the current Udacity user
    ///
    /// - Parameter data: Struct Session from udacity api
    /// - Returns: The Session struct without the **account** json node from login
    func parseSession(data: Data?) -> (Session?, Error?) {
        var sessionData: (session: Session?, error: Error?) = (nil, nil)
        do {
            
            struct SessionData: Codable {
                let session: Session
            }
            
            if let data = data {
                let jsonDecoder = JSONDecoder()
                sessionData.session = try jsonDecoder.decode(SessionData.self, from: data).session
            }
        } catch {
            print(error)
            sessionData.error = error
        }
        return sessionData
    }
    
    
    
    func authenticateFacebookUser(accessToken: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // Build Json body of request
        let facebookMobile = FacebookMobile(accessToken: accessToken)
        let postData = FaceBookUser(facebookMobile: facebookMobile)
        let encoder = JSONEncoder()
        let jsonBody = try! encoder.encode(postData)
        let jsonData = String(data:jsonBody, encoding: .utf8)!
        let urlPath = UdacityClient.UdacityMethods.Authentication
        
        _ = HTTPCLient.shared().taskForPostOrPutMethod(
            url:urlPath,
            jsonBody:jsonData,
            parameters: [:],
            apiType: HTTPCLient.APIType.udacity,
            completionHandlerForPost: { (data, error) in
                if let error = error {
                    print(error)
                    completionHandlerForAuth(false, error.localizedDescription)
                } else {
                    
                    do {
                        let userSession = try UserSession(data: data!)
                        if !userSession.account.registered {
                            completionHandlerForAuth(false, "Login falhou, usuário não registrado.")
                        }else {
                            self.userSession = userSession
                            completionHandlerForAuth(true, nil)
                        }
                    }
                    catch {
                        // what kind of error can happen here ?
                        print("Não foi possível encontrar os dados de Usuário.")
                        completionHandlerForAuth(false, error.localizedDescription)
                    }
                }
        })
    }
}
