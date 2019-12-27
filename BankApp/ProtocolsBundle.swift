//
//  TableProtocol.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//
import Foundation

protocol EventReceiverProtocol{
    func initSegueFromSubview(data: Any?, segue: SegueID)
}

protocol TableSegueProtocol{
    func prepareForSegue(data: Any?, segue: SegueID)
}

protocol Encodable {
    var encoded: Decodable? { get }
}

protocol Decodable {
    var decoded: Encodable? { get }
}

class Mainframe: UIViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation = self.navigationController as! RouterProtocol
        navigation.invoke?(with: segue, sender: sender)
    }
}
