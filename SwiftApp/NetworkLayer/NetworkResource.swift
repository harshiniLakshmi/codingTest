//
//  NetworkResource.swift
//  SwiftApp
//
//  Created by Harshini Lakshmi on 30/07/18.
//  Copyright © 2018 Harshini Lakshmi. All rights reserved.
//

import Foundation
import Alamofire //library to make api call
import SwiftyJSON //library to parse the json response

class NetworkResource {
    
    static let sharedInstance = NetworkResource()
    
    //method to make service call to get the response
    func serviceCall(requestURL: URL, completionHandler: @escaping (_ finalResponseDict: NSMutableDictionary) -> Void) {
//        __weak NetworkResource *weakSelf = self
        var responseDictionary: NSMutableDictionary = [:]
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "GET"
        Alamofire.request(urlRequest)
            .responseString {[weak self] response in
                switch response.result {
                case .success(let value):
                    let json = JSON.init(parseJSON:value)
                    if let responseDict = self?.parseJSONResponse(jsonData: json) as? NSMutableDictionary {
                        responseDictionary = responseDict
                        completionHandler(responseDictionary)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    //Parser, parse the json response and load it to an array using the model
    func parseJSONResponse(jsonData: SwiftyJSON.JSON) -> NSDictionary {
        let responseDict:NSMutableDictionary = [:]
        var responseArray = [AnyObject]()
        let title = jsonData["title"].stringValue
        responseDict.setValue(title, forKey: "title")
        
        for object in jsonData["rows"].arrayValue {
            let subTitle = object["title"].stringValue
            let description = object["description"].stringValue
            let imageURL = object["imageHref"].stringValue
            if (!subTitle.isEmpty || !description.isEmpty || !imageURL.isEmpty) {
                let item = ResponseData(imageURL: imageURL, withTitle: subTitle, andDescription: description)
                
                responseArray.append(item)
            }
        }
        responseDict.setValue(responseArray, forKey: "rows")
        return responseDict
    }
}
