//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Carl Lee on 9/28/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation

class UdacityClient: NSObject{
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func taskForPostMethod(username: String, password: String, method: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: udacityURL(withPathExtension: method) as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }

            
            guard (error == nil) else{
                sendError(error: (error?.localizedDescription)!)
                return
            }
            
            guard let statcode = (response as? HTTPURLResponse)?.statusCode, statcode >= 200 && statcode <= 299 else{
                sendError(error: "The login credential is invalid, try again!")
                return
            }
            
            guard let data = data else{
                sendError(error: "No data was returned by the request")
                return
            }
           
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConverData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }
    
    func taskForGetMethod(method: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: udacityURL(withPathExtension: method) as URL)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }

            
        guard (error == nil) else{
            sendError(error: (error?.localizedDescription)!)
            return
        }
        
        guard let statcode = (response as? HTTPURLResponse)?.statusCode, statcode >= 200 && statcode <= 299 else{
            sendError(error: "Your request returned a status code other than 2XX.")
            return
        }
        
        guard let data = data else{
            sendError(error: "No data was returned by the request")
            return
        }
        
        self.convertDataWithCompletionHandler(data: data, completionHandlerForConverData: completionHandlerForGET)
    }
        task.resume()
        return task

    }
    
    func taskForDeleteMethod(method: String, completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: udacityURL(withPathExtension: method) as URL)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDelete(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            
            guard (error == nil) else{
                sendError(error: (error?.localizedDescription)!)
                return
            }
            
            guard let statcode = (response as? HTTPURLResponse)?.statusCode, statcode >= 200 && statcode <= 299 else{
                sendError(error: "Your request returned a status code other than 2XX.")
                return
            }
            
            guard let data = data else{
                sendError(error: "No data was returned by the request")
                return
            }
            
           self.convertDataWithCompletionHandler(data: data, completionHandlerForConverData: completionHandlerForDelete) 
            
        }
        
        task.resume()
        return task

        
    }
    
    func convertDataWithCompletionHandler(data: Data, completionHandlerForConverData: (_ result:AnyObject?, _ error: NSError?) -> Void){
        
        let dataLength = data.count
        let r = 5...Int(dataLength)
        let newData = data.subdata(in: Range(r))
        
        let parseData: Any
        do{
            parseData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            
        } catch {
            print("error")
            return
        }
        
        completionHandlerForConverData(parseData as AnyObject?, nil)
        
    }
    
    private func udacityURL(withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constant.ApiScheme
        components.host = UdacityClient.Constant.ApiHost
        components.path = UdacityClient.Constant.ApiPath + (withPathExtension ?? "")
        print(components)
        print(components.url)
        return components.url! as NSURL
        
    }
    
    func subsituteForKey(method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else{
            return nil
        }
    }
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

    
}
