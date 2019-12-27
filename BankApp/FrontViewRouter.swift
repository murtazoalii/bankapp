//
//  FrontViewRouter.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

@objc public protocol RouterProtocol{
    @objc optional
    func invoke(with segue: UIStoryboardSegue, sender: Any?) -> Void
}

class FrontViewRouter: UINavigationController, RouterProtocol {
}

class FrontViewNavBar: UINavigationBar
{
    let bgColor: UIColor = #colorLiteral(red: 0.4315513968, green: 0.7840228081, blue: 0.3768854439, alpha: 1)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.barTintColor = bgColor
    }
    
}


