//
//  CustomCollectionViewCell.swift
//  SwiftApp
//
//  Created by Harshini Lakshmi on 24/07/18.
//  Copyright © 2018 Harshini Lakshmi. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    //**************************************************
    // MARK: - Enum Constants
    //**************************************************
    
    enum Constants {
        static let reuseIdentifier = "CustomCollectionViewCell"
        static let height: CGFloat = 200
        
    }
    
    //**************************************************
    // MARK: - IBOutlets
    //**************************************************
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDEscription: UILabel!
//    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var topPaddingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var bottomPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    var imageURL:String?
    
    
    //**************************************************
    // MARK: - Methods
    //**************************************************
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.frame = self.bounds
        containerView.layer.cornerRadius = 4
        containerView.layer.masksToBounds = true
    }
    
    /**
     load the content of each cell based on the parsed info received from the controller
     */
    func configureCell(withData responseData: ResponseData) {
        self.cellTitle.text = responseData.title
        self.cellDEscription.text = responseData.description
        self.iconImageView.image = nil
        self.imageURL = responseData.iconImageURL
        if let url = URL(string: self.imageURL!) {
            iconImageView.contentMode = .scaleAspectFit
            downloadImageAndLoadFrom(imageUrl: url)
        }
        else {
            self.loadDefaultImage()
        }
    }
    
    /**
     method to download the image asynchronously and then load in the imageView
     */
    private func downloadImageAndLoadFrom(imageUrl: URL) {
        getDataFromUrl(url: imageUrl) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.loadDefaultImage()
                return
            }
            DispatchQueue.main.async() {
                self?.iconImageView.image = UIImage(data: data)
            }
        }
    }
    
    /**
     method to get the data of the image URL in the response
     */
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode != 200) {
                    self?.loadDefaultImage()
                }
            }
            completion(data, response, error)
            }.resume()
    }
    
    
    /**
     method to load a default image if in any case image from server doesn't exists
     */
    private func loadDefaultImage() {
        DispatchQueue.main.async() {
            self.iconImageView.image = UIImage(named: "default")
        }
    }
    
//    func getConstraintConstants() -> (
//        CGFloat, CGFloat, CGFloat) {
//            let imageViewHeight = self.imageViewHeight.constant
//            let topPadding = self.topPaddingConstraint.constant
//            let bottomPadding = self.bottomPaddingConstraint.constant
//            
//            return (imageViewHeight, topPadding, bottomPadding)
//    }
}
