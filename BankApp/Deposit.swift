//
//  Deposit.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import Foundation

class Deposit: NSObject{
    let initialSum: Int
    let date: String
    
    init(initialSum: Int, date: String){
        self.initialSum = initialSum
        self.date = date
    }
}
