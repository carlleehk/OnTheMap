//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Carl Lee on 9/30/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

struct userData {
    let userFirstName: String
    let userLastName: String
    let userURL: String?
    
    init(dictionary: [String:Any]) {
        userFirstName = dictionary["first_name"] as! String
        userLastName = dictionary["last_name"] as! String
        userURL = dictionary["link"] as? String
    }
    
    static func userInfo(results:[[String: Any]]) -> [userData]{
        var data = [userData]()
        for result in results{
            data.append(userData(dictionary: result))
        
        }
        return data
    }
    
}
