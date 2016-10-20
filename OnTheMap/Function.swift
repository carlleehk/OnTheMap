//
//  Function.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/19/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation

func urlWithoutParameter(withPathExtension: String? = nil) -> NSURL {
    
    let components = NSURLComponents()
    components.scheme = UdacityClient.Constant.ApiScheme
    components.host = UdacityClient.Constant.ApiHost
    components.path = UdacityClient.Constant.ApiPath + (withPathExtension ?? "")
    print(components)
    print(components.url)
    return components.url! as NSURL
    
}
