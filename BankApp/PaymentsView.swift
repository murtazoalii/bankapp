//
//  PaymentsView.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

class PaymentsView: UITableView, TableSegueProtocol {

    let tableViewDelegate = PaymentsTableDelegate()
    var parent: EventReceiverProtocol!
    
    override func awakeFromNib() {
        self.delegate = tableViewDelegate
        self.dataSource = tableViewDelegate
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    func prepareForSegue(data: Any?, segue: SegueID) {
        self.parent.initSegueFromSubview(data: data, segue: segue)
    }
    
}
