//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/17/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

extension ParseClient{
    struct Constants{
       
        static let httpHeaderID = "X-Parse-Application-Id"
        static let httpHeaderAPI = "X-Parse-REST-API-Key"
        static let ApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
    }
    
    struct Method{
        static let objectID = "/{objectID}"
    }
    
    struct ParameterKeys {
        static let limit = "limit"
        static let skip = "skip"
        static let unique = "where"
        
    }
    
    
    
}
