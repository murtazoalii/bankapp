//
//  HomeTableView.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

class HomeTableView: UITableView, TableSegueProtocol {

    var parent: EventReceiverProtocol!
    let tableViewDelegate = TableViewDelegate()
    let nibs = ["CardCell", "DepositCell", "GoalCell"]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(initDrawing(_:)), name: .CardsHaveBeenLoadedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(initDrawing(_:)), name: .DepositsHaveBeenLoadedNotification, object: nil)
        self.tableFooterView = UIView(frame: CGRect.zero)
        self.registerNibs()
        self.layer.opacity = 0
    }
    
    func initDrawing(_ sender: Any?){
        self.delegate = tableViewDelegate
        self.dataSource = tableViewDelegate
        self.reloadData()
        
        if let vc = parent as? HomeWireframe{
            vc.activityIndicator.stopAnimating()
        }
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.layer.opacity = 1
        }, completion: nil)
    }
    
    func registerNibs(){
        
        for i in 0..<nibs.count{
            let nib = UINib(nibName: nibs[i], bundle: nil)
            self.register(nib, forCellReuseIdentifier: nibs[i])
        }
        
    }
    
    func prepareForSegue(data: Any?, segue: SegueID){
        self.parent.initSegueFromSubview(data: data, segue: segue)
    }
   

}
