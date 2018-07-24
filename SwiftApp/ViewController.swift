//
//  ViewController.swift
//  SwiftApp
//
//  Created by Harshini Lakshmi on 23/07/18.
//  Copyright © 2018 Harshini Lakshmi. All rights reserved.
//

import UIKit
import Alamofire //library to make api call
import SwiftyJSON //to parse the json response

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let apiUrl = URL(string : "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
    var parsedJSONArray = [AnyObject]()
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceCall(requestURL: apiUrl)
    }
    
    //method to make service call to get the response
    func serviceCall(requestURL: URL) {
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "GET"
        Alamofire.request(urlRequest)
            .responseString { response in
                switch response.result {
                case .success(let value):
                    let json = JSON.init(parseJSON:value)
                    self.parseJSONResponse(jsonData: json)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    //Parser, parse the json response and load it to an array using the model
    func parseJSONResponse(jsonData: SwiftyJSON.JSON) {
        let mainTitle = jsonData["title"].stringValue
        self.navigationItem.title = mainTitle
        for eachItem in jsonData["rows"].arrayValue {
            let title = eachItem["title"].stringValue
            let description = eachItem["description"].stringValue
            let imageURL = eachItem["imageHref"].stringValue
            if (!title.isEmpty || !description.isEmpty || !imageURL.isEmpty) {
                let combinedItem = ResponseData(imageURL: imageURL, withTitle: title, andDescription: description)
                self.parsedJSONArray.append(combinedItem)
            }
        }
        self.mainCollectionView!.reloadData()
    }
    
    // MARK: UICollectionView delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.parsedJSONArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.loadCell(withData: self.parsedJSONArray[indexPath.row] as! ResponseData)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
