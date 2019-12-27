//
//  Card.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import Foundation

extension String{
    func fromBase64() -> String?
    {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String
    {
        return Data(self.utf8).base64EncodedString()
    }
}

enum CardType:Int
{
    case credit = 0
    case debit = 1
    case overdraft = 2
}

enum CardProducer:Int
{
    case visa = 0
    case mastercard = 1
    case maestro = 2
}

class CardInfo: NSObject, NSCoding
{
    let type: CardType
    let title: CardProducer
    let number: String
    let cvv: Int
    
    init(type: CardType, title: CardProducer, number: String, cvv: Int){
        self.type = type
        self.title = title
        self.number = number
        self.cvv = cvv
    }
 
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.title.rawValue, forKey: "title")
        aCoder.encode(self.number, forKey: "number")
        aCoder.encode(self.cvv, forKey: "cvv")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = CardType(rawValue: aDecoder.decodeInteger(forKey: "type"))!
        self.title = CardProducer(rawValue: aDecoder.decodeInteger(forKey: "title"))!
        self.number = aDecoder.decodeObject(forKey: "number") as! String
        self.cvv = aDecoder.decodeInteger(forKey: "cvv")
    }
    
}

class Card: NSObject, NSCoding{
    let id: Int
    let title: String
    let info: CardInfo
    let balance: Int
    
    init(id: Int, title: String, info: CardInfo, balance: Int) {
        self.id = id
        self.title = title
        self.info = info
        self.balance = balance
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.balance, forKey: "balance")
        aCoder.encode(self.info, forKey: "info")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.info = aDecoder.decodeObject(forKey: "info") as! CardInfo
        self.balance = aDecoder.decodeInteger(forKey: "balance")
    }
    
}

class CardTest: NSObject, NSCoding{
    let id: Int
    let title: String
    let balance: Int
    
    init(id: Int, title: String, balance: Int) {
        self.id = id
        self.title = title
        self.balance = balance
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.balance, forKey: "balance")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.balance = aDecoder.decodeInteger(forKey: "balance")
    }
}
