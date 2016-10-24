//
//  ParseData.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/15/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

struct individualInfo{
    static var haveData: Bool = false
    static var location: String? = ""
    static var locationLong: Double? = nil
    static var locationLat: Double? = nil
    static var userURL: String? = ""
    static var objectID: String = ""

}

struct selectUserInfo{
    
    
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    
    static var selectuserInfo: [selectUserInfo] = []
    
    static var userInfoDictionary: [[String: Any]] = []
    
    init(dictionary: [String:Any]){
        
        
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        objectId = dictionary["objectId"] as? String
        
    }
    
    static func selectUserInfos(results:[[String: Any]]) -> [selectUserInfo]{
        
        var data = [selectUserInfo]()
        
        for result in results{
            data.append(selectUserInfo(dictionary: result ))
        }
        return data
    }

    
}
