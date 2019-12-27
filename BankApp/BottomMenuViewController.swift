//
//  BottomMenuViewController.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

class BottomMenuViewController: MenuContainer {

    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var profileLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.dataTable.delegate = delegate
        self.mainTable = dataTable
        profileLabel.text = getUserInfo()
    }
    
    func getUserInfo() -> String{
        let user = UserDefaults.standard.loadObjectWithKey(key: "user") as! User
        let fullname = user.fullname
        return fullname
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signOutSegue"
        {
            UserDefaults.standard.removeObject(forKey: "user")
            UserDefaults.standard.synchronize()
        }

    }
    
    

}
