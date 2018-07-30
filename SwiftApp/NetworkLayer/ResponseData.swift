//
//  ResponseData.swift
//  SwiftApp
//
//  Created by Harshini Lakshmi on 24/07/18.
//  Copyright © 2018 Harshini Lakshmi. All rights reserved.
//

import Foundation

//Model class mapping the json response
class ResponseData {
    var iconImageURL : String?
    var title : String?
    var description : String?
    
    init(imageURL iconImageURL: String?, withTitle title: String?, andDescription description: String?) {
        self.iconImageURL = iconImageURL
        self.title = title
        self.description = description
    }
}
