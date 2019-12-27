//
//  OperationManager.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import Foundation

public protocol OperationDataDelegate: class
{
    func operationsDidLoad(operations: NSArray)
}

class OperationManager: NSObject, URLSessionDataDelegate{
    static let instance = OperationManager()
    
    weak var delegate: OperationDataDelegate!
    var data: NSMutableData!
    var urlPath: String!
    
    func loadOperations(ownerID: Int)
    {
        urlPath = "http://thehomeland.ru/service/operation.php?owner=\(ownerID)&limit=10"
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
        let operations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            
            jsonDictionary = jsonResult[i] as! NSDictionary
            
            let date = jsonDictionary["date"] as! String
            let sum = Float(jsonDictionary["sum"] as! String)!
            let bill = jsonDictionary["bill"] as! String
            let receiver = Int(jsonDictionary["receiver"] as! String)!
            let owner = Int(jsonDictionary["owner"] as! String)!
            let receiverID = jsonDictionary["receiverId"] as! NSDictionary
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            let day = date.components(separatedBy: "-")[2]
            let month = date.components(separatedBy: "-")[1]
            let dateString = "\(day).\(month)"
            let formattedDate = formatter.date(from: dateString)!
            
            let operation = Operation(date: formattedDate, sum: sum, bill: bill, receiverID: receiverID, receiver: Receiver(rawValue:receiver)!, owner: owner)
            operations.add(operation)
            
        }
        
        DispatchQueue.main.async {
            self.delegate.operationsDidLoad(operations: operations)
        }
    }
    
}
