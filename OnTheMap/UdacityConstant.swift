//
//  OTMConstant.swift
//  OnTheMap
//
//  Created by Carl Lee on 9/28/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constant {
        
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    
    }
    
    
    struct Methods {
        static let session = "/session"
        static let users = "/users/{userID}"
    }

}
