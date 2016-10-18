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
                self.getUserData(completionHandlerForID: { (success, userData, String) in
                    if success{
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
        //let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        taskForPostMethod(username: username, password: password, method: Methods.session) { (result, error) in
            if let error = error {
                print(error)
                completionHandlerForID(false, nil, "Login Failed (session ID)")
            } else {
                if let jsonAccount = result!["account"] as? [String: AnyObject] {
                    if let regesited = jsonAccount["registered"] as? Bool, let userID = jsonAccount["key"] as? String {
                        userData.userID = userID
                        userData.userStat = regesited
                        completionHandlerForID(true, userID, nil)
                    } else{
                        print(error)
                        completionHandlerForID(false, nil, "Login Failed")
                    }
                }else{
                    print(error)
                    completionHandlerForID(false, nil, "Login Failed")
                }
            }
        }
    }
    
    
    private func getUserData(completionHandlerForID: @escaping (_ success: Bool, _ userData: [String: AnyObject]?, _ error: String?) -> Void){
        
        var mutableMethod: String = Methods.users
        mutableMethod = subsituteForKey(method: mutableMethod, key: "userID", value: userData.userID)!
        taskForGetMethod(method: mutableMethod) { (result, error) in
            if let error = error{
                print(error)
                completionHandlerForID(false, nil, "Login Failed (user Data)")
            } else {
                guard let user = result!["user"] as? [String: AnyObject] else{
                    print(error)
                    return
                }
                
                guard let firstName = user["first_name"], let lastName = user["last_name"] else{
                    print(error)
                    return
                }
                
                userData.userFirstName = firstName as! String
                userData.userLastName = lastName as! String
                
                /*let data = userData.userInfo(results: [user])
                userData.userInfo = data*/
                completionHandlerForID(true, user, nil)
            }
        }
    }
}


