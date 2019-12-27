//
//  HomeRouter.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit


class HomeRouter: FrontViewRouter {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func invoke(with segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardDescriptionWireframe{
            destination.card = sender as! Card
        }
    }

}
