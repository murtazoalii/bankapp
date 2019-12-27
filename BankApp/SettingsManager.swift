//
//  SettingsManager.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import Foundation


public protocol SettingsManagerDelegate: class
{
    func dataHasBeenSent()
}

class SettingsManager:NSObject, URLSessionDataDelegate
{
    static let instance = SettingsManager()
    
    weak var delegate: SettingsManagerDelegate!
    var data: NSMutableData!
    var urlPath:String!
    
    
    func uploadData(id: Int, password: String, oldPassword: String)
    {
        urlPath = "http://thehomeland.ru/service/settings.php?id=\(id)&password=\(password)&oldPassword=\(oldPassword)"
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
