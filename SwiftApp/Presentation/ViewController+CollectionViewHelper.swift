//
//  ViewController+CollectionViewHelper.swift
//  SwiftApp
//
//  Created by Harshini Lakshmi on 30/07/18.
//  Copyright © 2018 Harshini Lakshmi. All rights reserved.
//

import Foundation
import UIKit

extension ViewController : CustomCollectionViewLayoutDelegate {
    
    
    var items: [AnyObject] {
        var items = [AnyObject]()
        if let responseDict = responseDictionary,
            let responseItems = responseDict["rows"] as? [AnyObject] {
            items = responseItems as [AnyObject]
            return items
        }
        return items
    }
    
    //***************************************************************
    // MARK: - CollectionView Delegate and Datasource methods
    //***************************************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.Constants.reuseIdentifier, for: indexPath) as? CustomCollectionViewCell {
            cell.configureCell(withData: items[indexPath.row] as! ResponseData)
            self.mainCollectionView.collectionViewLayout.prepare()
            return cell
        }
        return UICollectionViewCell()
    }
    
    //***************************************************************
    // MARK: - CollectionView Custom Layout Delegate methods
    //***************************************************************
    
    func collectionView(collectionView: UICollectionView, heightForImageAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        return CustomCollectionViewCell.Constants.height
    }
    
    func collectionView(collectionView: UICollectionView, heightForTitleAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        if let currentData = items[indexPath.row] as? ResponseData {
            let captionFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
            let captionHeight = self.height(for: currentData.title!, with: captionFont, width: width)
            let height = captionHeight
            return height
        }
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, heightForDescriptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        if let currentData = items[indexPath.row] as? ResponseData {
            let captionFont = UIFont.systemFont(ofSize: 15)
            let captionHeight = self.height(for: currentData.description!, with: captionFont, width: width)
            let height = captionHeight
            
            return height
        }
        return 0.0
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat
    {
        let someString = NSString(string: text)
        let maxHeight = CGFloat(300.0)
        let textAttributes = [NSAttributedStringKey.font : font]
        let boundingRect = someString.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.mainCollectionView.collectionViewLayout.invalidateLayout()
        self.mainCollectionView.layoutIfNeeded()
    }
}
