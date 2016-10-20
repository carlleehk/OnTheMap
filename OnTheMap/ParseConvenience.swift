//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/17/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient{
    
    func getStudentsData(completionHandlerForGetStudentsData:@escaping (_ result:[selectUserInfo]?, _ error:NSError?) -> Void){
        
        let random = arc4random_uniform(1400)
        let parameters = [ParameterKeys.limit: "99", ParameterKeys.skip: "\(random)"]
        taskForGetMethod(parameters: parameters as [String : AnyObject]) { (results, error) in
            if let error = error{
                completionHandlerForGetStudentsData(nil, error)
            } else {
                guard let info = results?["results"]! as? [[String: Any]] else{
                    print("the error is: \(error)")
                    return
                }
                
                print(info)
                let data = selectUserInfo.selectUserInfos(results: info)
                selectUserInfo.selectuserInfo = data
                completionHandlerForGetStudentsData(data, nil)
            }
        }
    }
    
    func getIndividualData(completionHandlerForGetStudentsData:@escaping (_ result:[selectUserInfo]?, _ error:NSError?) -> Void){
        
        let parameters = [ParameterKeys.unique: "{\"uniqueKey\":\"\(userData.userID)\"}"]
        taskForGetMethod(parameters: parameters as [String : AnyObject]) { (results, error) in
            if let error = error{
                completionHandlerForGetStudentsData(nil, error)
            } else {
                guard let info = results?["results"]! as? [[String: Any]] else{
                    print("the error is: \(error)")
                    return
                }
                
                print("the data is: \(info)")
                let data = selectUserInfo.selectUserInfos(results: info)
                selectUserInfo.selectuserInfo = data
                print("the data is: \(selectUserInfo.selectuserInfo)")
                completionHandlerForGetStudentsData(data, nil)
            }
        }
    }

    
    func postNewStudent(completionHandlerForPostStudentsData:@escaping (_ result:String?, _ error:NSError?) -> Void){
        
        taskForPostMethod { (results, error) in
            
            if let error = error{
                completionHandlerForPostStudentsData(nil, error)
            } else {
                guard let info = results?["objectId"]! as? String else{
                    print("the error is: \(error)")
                    return
                }
                
                individualInfo.objectID = info
                print(individualInfo.objectID)
                completionHandlerForPostStudentsData(info, nil)
                
            }
        }
    }
    
    func renewStudentLocation(completionHandlerForPut: @escaping (_ result:String?, _ error:NSError?) -> Void){
        
        var mutableMethod: String = Method.objectID
        print(",,,: \(individualInfo.objectID)")
        mutableMethod = subsituteForKey(method: mutableMethod, key: "objectID", value: individualInfo.objectID)!
        print(",,,: \(mutableMethod)")
        taskForPutMethod(method: mutableMethod) { (result, error) in
            
            if let error = error{
                completionHandlerForPut(nil, error)
            } else {
                guard let info = result?["updatedAt"]! as? String else{
                    print("the error is: \(error)")
                    return
                }
                
                completionHandlerForPut(info, nil)
                
            }
 
        }
    }
    
}
