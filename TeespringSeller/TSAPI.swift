//
//  TSAPI.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 2/4/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import Foundation
import Alamofire

let HOST = "api2.teedown.com"
let PORT = 443
let APP_ID = "e60c5b0535c5600bc074d2306e2dca7a2d4a692379417f43253db0c2e2254ff0"

let PATHS = [
    "auth": "/seller/v1/auth",
    "dashboard": "/seller/v1/dashboard",
    "campaigns": "/seller/v1/campaigns",
    "orders": "/seller/v1/orders",
]

struct TSAPI {
    var paths = [String: NSURLComponents]()
    let accessToken : String
    let appId: String
    var baseUrl: String
    
    init(host: String = HOST, port: Int = PORT, token: String = "", appId: String = APP_ID) {
        for (name, path) in PATHS {
            let url = NSURLComponents()
            url.scheme = "https"
            url.host = host
            url.path = path
            url.port = port
            self.paths[name] = url
        }
        self.baseUrl = "https://\(host):\(port)"
        self.accessToken = token
        self.appId = appId
    }
    
    func getAccessToken(email: String, password: String, successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        Alamofire.request(.POST, "\(self.baseUrl)\(PATHS["auth"]!)", parameters: ["email": email, "password": password, "app_id": self.appId])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let JSON = response.result.value {
                        if let error = JSON["error"] { // placeholder until we can use .Failure case
                            if let _ = error {
                                errorCallback!(NSError(domain: "placeholder", code: 400, userInfo: JSON as? [NSObject : AnyObject]))
                            } else {
                                successCallback(JSON as! NSDictionary)
                            }
                        }
                    }
                case .Failure(let error):
                    // TODO: Make API return error codes for login and use this instead
                    errorCallback!(error)
                }
        }
    }
    
    func getDashboard(successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        networkRequest("dashboard", params: ["access_token": self.accessToken], successCallback: successCallback, errorCallback: errorCallback)
    }
    
    func getOrders(successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        networkRequest("orders", params: ["access_token": self.accessToken], successCallback: successCallback, errorCallback: errorCallback)
    }
    
    func getCampaigns(searchTerm: String? = nil, successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        var params = [String:String]()
        params["access_token"] = self.accessToken
        params["states"] = "active,success"
        if let q = searchTerm { params["query"] = q }
        networkRequest("campaigns", params: params, successCallback: successCallback, errorCallback: errorCallback)
    }
    
    private func networkRequest(pathName: String, params: [String:String], successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        let urlComponents = paths[pathName]
        let queryItems = params.map{ (k,v) in NSURLQueryItem(name: k, value: v) }
        urlComponents?.queryItems = queryItems
        let url = urlComponents?.URL!
        
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        NSLog("requestUrl: \(url)")
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                if let requestError = errorOrNil {
                    errorCallback?(requestError)
                } else {
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                NSLog("response: \(responseDictionary)")
                                successCallback(responseDictionary)
                        }
                    }
                }
        });
        task.resume()
    }
    
}
