//
//  User.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

extension UserDefaults
{
    func saveObject(object: Any, key: String)
    {
        let encoded = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(encoded, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    func loadObjectWithKey(key: String) -> Any?
    {
        guard let encoded = UserDefaults.standard.object(forKey: key) as? Data else
        {
            return nil
        }
        let object = NSKeyedUnarchiver.unarchiveObject(with: encoded)
        return object
        
    }
    
    func loadArrayWithKey(key: String) -> [Any?]{
        guard let encoded = UserDefaults.standard.array(forKey: key) as? [Data] else
        {
            return [Any?]()
        }
        let object = encoded.map{
            NSKeyedUnarchiver.unarchiveObject(with: $0)
        }
        
        return object
    }
    
}

class User: NSObject, NSCoding {

    let fullname: String
    let email: String
    let password: String
    var code: String?
    let id: Int
    var imgURL: String?
    var img: UIImage?
    
    init(fullname: String, email: String, password: String, id: Int, imgURL: String?, img: UIImage?) {
        self.fullname = fullname
        self.email = email
        self.password = password
        self.id = id
        self.img = img
        self.imgURL = imgURL
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.fullname, forKey: "fullname")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.code, forKey: "code")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.img, forKey: "img")
        aCoder.encode(self.imgURL, forKey: "imgURL")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.fullname = aDecoder.decodeObject(forKey: "fullname") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.password = aDecoder.decodeObject(forKey: "password") as! String
        self.code = aDecoder.decodeObject(forKey: "code") as? String
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.img = aDecoder.decodeObject(forKey: "img") as? UIImage
        self.imgURL = aDecoder.decodeObject(forKey: "imgURL") as? String
    }

    
}
