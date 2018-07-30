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

    //**************************************************
    // MARK: - Enum Constants
    //**************************************************
    
    enum Constants {
        static let apiUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    }
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    let apiUrl = URL(string: Constants.apiUrl)
    var parsedJSONArray = [AnyObject]()
    var responseDictionary: NSDictionary?
    
    //**************************************************
    // MARK: - IBOutlets
    //**************************************************
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout?
    private var refreshControl = UIRefreshControl()
    
    //**************************************************
    // MARK: - View Life Cycle Methods
    //**************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        initiateAPICall()
    }
    
    //**************************************************
    // MARK: - Private Methods
    //**************************************************
    
    private func initiateAPICall() {
        NetworkResource.sharedInstance.serviceCall(requestURL: apiUrl!) { (finalResponseDictionary) in
            self.responseDictionary = finalResponseDictionary
            self.mainCollectionView.reloadData()
            self.navigationItem.title = (self.responseDictionary!["title"] as! String)
        }
    }

    //**************************************************
    // MARK: - Set Up UI
    //**************************************************
    
    func setupCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView?.contentInset = UIEdgeInsets(top: 12, left: 4, bottom: 12, right: 4)
        if #available(iOS 10.0, *) {
            mainCollectionView.refreshControl = refreshControl
        } else {
            mainCollectionView.addSubview(refreshControl)
        }
        
        if let layout = mainCollectionView?.collectionViewLayout as? CustomCollectionViewLayout {
            layout.delegate = self
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        mainCollectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
