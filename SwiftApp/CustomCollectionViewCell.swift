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
    
    func loadCell(withData responseData: ResponseData) {
        self.cellTitle.text = responseData.title
        self.cellDEscription.text = responseData.description
    }
    
}
