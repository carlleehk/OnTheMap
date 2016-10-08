//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/6/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient{
    
    func authenticateViewController(username: String, password: String, hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        getSessionID(username: username, password: password){(success, sessionID, errorString) in
            if success{
                self.sessionIDs = sessionID!
                self.getUserData(completionHandlerForID: { (success, userData, String) in
                    if success{
                        print(userData)
                        completionHandlerForAuth(success, errorString)
                    }else {
                        completionHandlerForAuth(success, errorString!)
                    }
                })
            } else {
                completionHandlerForAuth(success, errorString!)
            }
        }
    }
    
    private func getSessionID(username: String, password: String, completionHandlerForID: @escaping (_ success: Bool, _ sessionID: String?, _ error: String?) -> Void){
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        taskForPostMethod(method: Methods.session, jsonBody: jsonBody) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForID(false, nil, "Login Failed (session ID)")
            } else {
                guard let jsonSession = result!["session"] as? [String: AnyObject], let jsonAccount = result!["account"] as? [String: AnyObject] else{
                    print("error")
                    return
                }
                
                guard let sessionID = jsonSession["id"] as? String, let accountKey = jsonAccount["key"] as? String else{
                    print("error")
                    return
                }
                self.sessionIDs = sessionID
                self.accountKeys = accountKey
                completionHandlerForID(true, sessionID, nil)
            }
        }
    }
    
    private func getUserData(completionHandlerForID: @escaping (_ success: Bool, _ userData: [String: Any]?, _ error: String?) -> Void){
        
        var mutableMethod: String = Methods.users
        mutableMethod = subsituteForKey(method: mutableMethod, key: "userID", value: self.accountKeys)!
        taskForGetMethod(method: mutableMethod) { (result, error) in
            if let error = error{
                print(error)
                completionHandlerForID(false, nil, "Login Failed (user Data)")
            } else {
                guard let user = result!["user"] as? [String: Any] else{
                    print(error)
                    return
                }
                
                guard let firstName = user["first_name"], let lastName = user["last_name"], let userURL = user["linkedin_url"] else{
                    print(error)
                    return
                }
                
                completionHandlerForID(true, user, nil)
            }
        }
    }
}


