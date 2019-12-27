//
//  MenuContainer.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

class MenuContainer: UITableViewController {

    let delegate = MenuViewDelegate()
    var mainTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate.parentController = self
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_:)), name: .DidSelectCellAtIndexNotification, object: nil)        
    }
    
    func notificationHandler(_ sender: Any?)
    {
        if self != (sender as! Notification).userInfo?["parent"] as? TopMenuViewController
        {
            self.delegate.updateCellsInTableView(tableView: mainTable)
        }
    }

}
