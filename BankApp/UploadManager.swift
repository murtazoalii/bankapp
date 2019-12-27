//
//  UploadManager.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import Foundation

public protocol UploadManagerDelegate: class
{
    func dataHasBeenSent()
}

class UploadManager:NSObject, URLSessionDataDelegate
{
    static let instance = UploadManager()
    
    weak var delegate: UploadManagerDelegate!
    var data: NSMutableData!
    var urlPath:String!
    
   
    func uploadData(date: String, sum: Int, bill: String, receiver: Int, cardNumber: String, owner: Int)
    {
        urlPath = "http://thehomeland.ru/service/extpayment.php?date=\(date)&sum=\(sum)&bill=\(bill)&receiver=\(receiver)&cardNumber=\(cardNumber)&owner=\(owner)"
        print(urlPath)
        data = NSMutableData()
        
        let url: URL = URL(string: urlPath)!
        var session: URLSession!
        let configuration = URLSessionConfiguration.default
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: url)
        task.resume()
        
    }
    
    func uploadData(date: String, sum: Int, bill: String, receiver: Int, receiverID: Int, owner: Int)
    {
        urlPath = "http://thehomeland.ru/service/payment.php?date=\(date)&sum=\(sum)&bill=\(bill)&receiver=\(receiver)&receiverId=\(receiverID)&owner=\(owner)"
        print(urlPath)
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
            print("Failed to upload data")
            return
        }
        else{
            print("Data has been uploaded")
            DispatchQueue.main.async {
                self.delegate.dataHasBeenSent()
            }
        }
    }
    
}
