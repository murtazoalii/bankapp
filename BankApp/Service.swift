//
//  Service.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import Foundation

class Service: NSObject{
    
    let title: String
    let category: Int
    let image: UIImage
    
    init(title: String, category: Int, image: UIImage){
        self.title = title
        self.category = category
        self.image = image
    }
    
    
}
