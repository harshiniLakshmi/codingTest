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
    
    func loadDefaultImage() {
        DispatchQueue.main.async() {
            self.iconImageView.image = UIImage(named: "default")
        }
    }
    
}
