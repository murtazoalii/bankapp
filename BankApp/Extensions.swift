//
//  Extensions.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import Foundation


public protocol ImageSessionDelegate: class{
    func imageDidLoad(image: UIImage)
}

class ImageManager: NSObject, URLSessionDataDelegate{
    
    var data: Data!
    weak var delegate:ImageSessionDelegate!
    static let instance = ImageManager()
    
    func downloadImage(urlString: String){
        let url = URL(string: urlString)!
        data = Data()
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: url)
        task.resume()
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            self.data.append(data)
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil{
            print("Process of downloading is finished with the error \(error)")
        }
        else{
            print("Image has been downloaded")
            
            DispatchQueue.main.async {
                let image = UIImage(data: self.data)!
                self.delegate.imageDidLoad(image: image)
            }
            
            
        }
    }
    
}

extension Sequence where Iterator.Element: Encodable {
    var encoded: [Decodable] {
        return self.filter({ $0.encoded != nil }).map({ $0.encoded! })
    }
}
extension Sequence where Iterator.Element: Decodable {
    var decoded: [Encodable] {
        return self.filter({ $0.decoded != nil }).map({ $0.decoded! })
    }
}

public extension Int{
    var stringFormat: String{
        return format()
    }
    
    func format() -> String{
        var array = [String]()
        var string = ""
        splitNumber(&array)
        reverseFill(string: &string, array: array)
        return string
    }
    
    func splitNumber(_ array: inout [String]){
        
        var number = self
        
        while number > 0 {
            let mod = number % 1000
            var modString = ""
            
            if mod == 0{
                modString = "000"
            }
            else{
                modString = "\(mod)"
            }
            
            array.append(modString)
            number = number / 1000
        }
    }
    
    func reverseFill(string: inout String, array:[String]){
        
        for i in 0..<array.count{
            var predicate = ""
            let j = array.count-i-1
            
            if j != array.count-1{
                predicate = ","
            }
            string += predicate+array[j]
        }
        
    }
    
}
