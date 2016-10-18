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
        
        let parameters = [ParameterKeys.limit: "4", ParameterKeys.skip: "100"]
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
}
