//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Carl Lee on 10/17/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation

class ParseClient: NSObject{
    
    var session = URLSession.shared
    
    override init(){
        super.init()
    }
    
    func taskForGetMethod(parameters: [String: AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters: parameters, withPathExtension: nil) as URL)
        request.addValue(Constants.AppicationID, forHTTPHeaderField: Constants.httpHeaderID)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.httpHeaderAPI)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print("the error is: \(error)")
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
    
    func taskForPostMethod(completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        let request = NSMutableURLRequest(url: parseURLWithoutParameter(withPathExtension: nil) as URL)
        request.httpMethod = "POST"
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.httpHeaderAPI)
        request.addValue(Constants.AppicationID, forHTTPHeaderField: Constants.httpHeaderID)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userData.userID)\", \"firstName\": \"\(userData.userFirstName)\", \"lastName\": \"\(userData.userLastName)\",\"mapString\": \"\(individualInfo.location!)\", \"mediaURL\": \"\(individualInfo.userURL!)\",\"latitude\": \(individualInfo.locationLat!), \"longitude\": \(individualInfo.locationLong!)}".data(using: String.Encoding.utf8)
        /*request.httpBody = "{\"uniqueKey\": \"\(userData.userID)\", \"firstName\": \"\(userData.userFirstName)\", \"lastName\": \"\(userData.userLastName)\",\"mapString\": \"\(individualInfo.userURL)\", \"mediaURL\": \"\(individualInfo.userURL)\",\"latitude\": \(individualInfo.locationLat), \"longitude\": \(individualInfo.locationLong)}".data(using: String.Encoding.utf8)*/
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print("the error is: \(error)")
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
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
            
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConverData: completionHandlerForPOST)
        }
        task.resume()
        return task
    }
    
    func taskForPutMethod(method: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: parseURLWithoutParameter(withPathExtension: method) as URL)
        request.httpMethod = "PUT"
        request.addValue(Constants.AppicationID, forHTTPHeaderField: Constants.httpHeaderID)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.httpHeaderAPI)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userData.userID)\", \"firstName\": \"\(userData.userFirstName)\", \"lastName\": \"\(userData.userLastName)\",\"mapString\": \"\(individualInfo.location!)\", \"mediaURL\": \"\(individualInfo.userURL!)\",\"latitude\": \(individualInfo.locationLat!), \"longitude\": \(individualInfo.locationLong!)}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(error: String) {
                print("the error is: \(error)")
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
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
            
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConverData: completionHandlerForPUT)
        }
        
        task.resume()
        return task

    }
    
    func convertDataWithCompletionHandler(data: Data, completionHandlerForConverData: (_ result:AnyObject?, _ error: NSError?) -> Void){
        
        
        let parseData: Any
        do{
            parseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
        } catch {
            print("error")
            return
        }
        
        completionHandlerForConverData(parseData as AnyObject?, nil)
        
    }

    
    private func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]() as [URLQueryItem]?
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem as URLQueryItem)
        }
        print(components)
        print("The url is: \(components.url)")
        return components.url! as NSURL
    }
    
    func parseURLWithoutParameter(withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
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
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }


}
