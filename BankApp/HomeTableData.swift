//
//  HomeTableData.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//
import Foundation

public protocol HomeTableDataDelegate: class
{
    func cardsDidLoad(cards: NSArray)
}

class HomeTableData:NSObject, URLSessionDataDelegate
{
    static let instance = HomeTableData()
    
    let sections = ["Карты","Открыть вклад","Вклады"]
    weak var delegate: HomeTableDataDelegate!
    var data: NSMutableData!
    var urlPath:String!

    
    func loadCards(id: Int)
    {
        urlPath = "http://thehomeland.ru/service/card.php?id=\(id)"
        data = NSMutableData()
        
        let url: URL = URL(string: urlPath)!
        var session: URLSession!
        let configuration = URLSessionConfiguration.default
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: url)
        task.resume()
        
    }
    
    //MARK: URLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if error != nil{
            print("Failed to download data")
            return
        }
        else{
            print("Data has been downloaded")
            self.parseJSON()
        }
    }
    
    func parseJSON(){
        var jsonResult = NSArray()
        
        do {
            try jsonResult = JSONSerialization.jsonObject(with: self.data as Data, options: .allowFragments) as! NSArray
        } catch let error {
            print(error)
        }
        
        var jsonDictionary = NSDictionary()
        let cards = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            
            jsonDictionary = jsonResult[i] as! NSDictionary
            
            let id = jsonDictionary["id"] as! String
            let title = jsonDictionary["title"] as! String
            let producer = jsonDictionary["producer"] as! String
            let type = jsonDictionary["type"] as! String
            let number = jsonDictionary["number"] as! String
            let cvv = jsonDictionary["cvv"] as! String
            let balance = jsonDictionary["balance"] as! String
            
            let cardInfo = CardInfo(type: CardType(rawValue: Int(type)!)!, title: CardProducer(rawValue:Int(producer)!)!, number: number, cvv: Int(cvv)!)
            let card = Card(id: Int(id)!, title: title, info: cardInfo, balance: Int(balance)!)
            cards.add(card)
            
        }
        
        DispatchQueue.main.async {
            self.delegate.cardsDidLoad(cards: cards)
        }
        
    }
    
}
