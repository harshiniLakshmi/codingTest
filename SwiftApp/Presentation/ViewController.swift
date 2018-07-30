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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CustomCollectionViewLayoutDelegate {

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
    
    var items: [AnyObject] {
        var items = [AnyObject]()
        if let responseDict = responseDictionary,
            let responseItems = responseDict["rows"] as? [AnyObject] {
            items = responseItems as [AnyObject]
            return items
        }
        return items
    }
    
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
        responseDictionary = NetworkResource.sharedInstance.serviceCall(requestURL: apiUrl!)
        //self.mainCollectionView.collectionViewLayout.prepare()
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
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        mainCollectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: UICollectionView delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.parsedJSONArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.Constants.reuseIdentifier, for: indexPath) as? CustomCollectionViewCell {
            cell.configureCell(withData: items[indexPath.row] as! ResponseData)
            self.mainCollectionView.collectionViewLayout.prepare()
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, heightForImageAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        return 200.0
    }
    
    func collectionView(collectionView: UICollectionView, heightForTitleAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        if let currentData = items[indexPath.row] as? ResponseData {
            let topPadding = CGFloat(4)
            let bottomPadding = CGFloat(4)
            let captionFont = UIFont.systemFont(ofSize: 15)
            let captionHeight = self.height(for: currentData.title!, with: captionFont, width: width)
            let height = topPadding + captionHeight + bottomPadding
            return height
        }
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, heightForDescriptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        if let currentData = items[indexPath.row] as? ResponseData {
            let topPadding = CGFloat(4)
            let bottomPadding = CGFloat(4)
            let captionFont = UIFont.systemFont(ofSize: 15)
            let captionHeight = self.height(for: currentData.description!, with: captionFont, width: width)
            let height = topPadding + captionHeight + bottomPadding
            
            return height
        }
        return 0.0
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat
    {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(300.0)
        let textAttributes = [NSAttributedStringKey.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
}
