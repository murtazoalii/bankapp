//
//  DepositManager.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import Foundation

public protocol DepositManagerDelegate: class
{
    func dataHasBeenSent()
}

class DepositManager: NSObject, URLSessionDataDelegate{
    static let instance = DepositManager()
    
    weak var delegate: DepositManagerDelegate!
    var data: NSMutableData!
    var urlPath: String!
    
    func uploadDeposit(sum: Int, term: String, ownerId: Int)
    {
        urlPath = "http://thehomeland.ru/service/deposit.php?sum=\(sum)&term=\(term)&owner=\(ownerId)"
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
            DispatchQueue.main.async {
                self.delegate.dataHasBeenSent()
            }
        }
    }
    
    
}
