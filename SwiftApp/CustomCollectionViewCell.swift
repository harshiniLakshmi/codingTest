//
//  CustomCollectionViewCell.swift
//  SwiftApp
//
//  Created by Harshini Lakshmi on 24/07/18.
//  Copyright © 2018 Harshini Lakshmi. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDEscription: UILabel!
    var imageURL:String?
    
    //load the content of each cell based on the parsed info received from the controller
    func loadCell(withData responseData: ResponseData) {
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
    
    //method to get the data of the image URL in the response
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode != 200) {
                    self.loadDefaultImage()
                }
            }
            completion(data, response, error)
            }.resume()
    }
    
    //method to download the image asynchronously and then load in the imageView
    func downloadImageAndLoadFrom(imageUrl: URL) {
        getDataFromUrl(url: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                self.loadDefaultImage()
                return
            }
            DispatchQueue.main.async() {
                self.iconImageView.image = UIImage(data: data)
            }
        }
    }
    
    //method to load a default image if in any case image from server doesn't exists
    func loadDefaultImage() {
        DispatchQueue.main.async() {
            self.iconImageView.image = UIImage(named: "default")
        }
    }
}
