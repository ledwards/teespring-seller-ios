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
let ROOT_WEB_URL = "https://www.teespring.com"

let PATHS = [
    "auth": "/seller/v1/auth",
    "dashboard": "/seller/v1/dashboard",
    "campaigns": "/seller/v1/campaigns",
    "orders": "/seller/v1/orders",
]

struct TSAPI {
    var paths = [String:String]()
    let accessToken : String
    let appId: String
    var baseUrl: String
    
    init(host: String = HOST, port: Int = PORT, token: String = "", appId: String = APP_ID) {
        self.paths = PATHS
        self.baseUrl = "https://\(host):\(port)"
        self.accessToken = token
        self.appId = appId
    }
    
    func getAccessToken(email: String, password: String, successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        apiRequest(Alamofire.Method.POST, pathName: "auth", parameters: ["email": email, "password": password, "app_id": self.appId], successCallback: successCallback, errorCallback: errorCallback)
    }
    
    func getDashboard(successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        apiRequest(Alamofire.Method.GET, pathName: "dashboard", parameters: ["access_token": self.accessToken], successCallback: successCallback, errorCallback: errorCallback)
    }
    
    func getOrders(successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        apiRequest(Alamofire.Method.GET, pathName: "orders", parameters: ["access_token": self.accessToken], successCallback: successCallback, errorCallback: errorCallback)
    }
    
    func getCampaigns(searchTerm: String? = nil, successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        let params = ["access_token": self.accessToken, "states": "active,success", "search": searchTerm ?? ""]
        apiRequest(Alamofire.Method.GET, pathName: "campaigns", parameters: params, successCallback: successCallback, errorCallback: errorCallback)
    }
    
    private func path(pathName: String) -> String {
        return "\(self.baseUrl)\(self.paths[pathName]!)"
    }
    
    private func apiRequest(verb: Alamofire.Method, pathName: String, parameters: [String:String], successCallback: (NSDictionary) -> Void, errorCallback: ((NSError?) -> Void)?) {
        Alamofire.request(verb, path(pathName), parameters: parameters)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .Success:
                if let JSON = response.result.value {
                    successCallback(JSON as! NSDictionary)
                }
            case .Failure(let error):
                errorCallback!(error)
            }
        }
    }
}
