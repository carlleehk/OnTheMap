//
//  ParseData.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/15/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

struct individualInfo{
    static var location: String? = ""
    static var locationLong: Double? = nil
    static var locationLat: Double? = nil
    static var userURL: String? = ""

}

struct selectUserInfo{
    
    var firstName: String?
    var lastName: String?
    var lat: Double?
    var long: Double?
    var location: String?
    var url: String?
    
    static var selectuserInfo: [selectUserInfo] = []
    
    init(dictionary: [String:Any]){
        firstName = dictionary["firstname"] as? String
        lastName = dictionary["lastname"] as? String
        lat = dictionary["latitude"] as? Double
        long = dictionary["longitude"] as? Double
        location = dictionary["mapString"] as? String
        url = dictionary["mediaURL"] as? String
    }
    
    static func selectUserInfos(results:[[String: Any]]) -> [selectUserInfo]{
        
        var data = [selectUserInfo]()
        
        for result in results{
            data.append(selectUserInfo(dictionary: result ))
        }
        return data
    }

    
}
