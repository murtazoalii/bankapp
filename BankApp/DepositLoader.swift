//
//  DepositLoader.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import Foundation

public protocol DepositLoaderDelegate: class
{
    func depositsHaveBeenLoaded(deposits: NSArray)
}

class DepositLoader: NSObject, URLSessionDataDelegate{
    static let instance = DepositLoader()
    
    weak var delegate: DepositLoaderDelegate!
    var data: NSMutableData!
    var urlPath: String!
    
    func uploadDeposit(id: Int)
    {
        urlPath = "http://thehomeland.ru/service/loadDeposit.php?id=\(id)"
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
        let deposits = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            
            jsonDictionary = jsonResult[i] as! NSDictionary
            
            let sum = Int(jsonDictionary["sum"] as! String)
            let term = jsonDictionary["term"] as! String
            
            let deposit = Deposit(initialSum: sum!, date: term)
            deposits.add(deposit)
            
        }
        
        DispatchQueue.main.async {
            self.delegate.depositsHaveBeenLoaded(deposits: deposits)
        }
        
    }

    
}
