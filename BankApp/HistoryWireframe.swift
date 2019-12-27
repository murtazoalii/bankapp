//
//  HistoryWireframe.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

class HistoryWireframe: Mainframe, HistoryDataDelegate, UITableViewDataSource, UITableViewDelegate {

    var history:[Operation] = []
    var historyData = HistoryManager.instance
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyData.delegate = self
        prepareTableForSetUp(tableView: table)
        let user = UserDefaults.standard.loadObjectWithKey(key: "user") as! User
        historyData.loadHistory(ownerID: user.id)
        
        self.addGestureToScene()
    }

    //TableView Setup
    
    func prepareTableForSetUp(tableView: UITableView){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        table.layer.opacity = 0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90.0
    }
    
    //MARK: - HistoryDataDelegate
    
    func historyDidLoad(history: NSArray) {
        self.history = history as! [Operation]
        table.reloadData()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.table.layer.opacity = 1
        }, completion: nil)
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count > 0 ? history.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if history.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
            
            let j = indexPath.row
            cell.operationBill.text = history[j].bill
            cell.operationSum.text = String(-history[j].sum) + " Р"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            cell.operationDate.text = formatter.string(from: history[j].date)
            
            var type = ""
            
            switch history[j].receiver{
            case .service:
                type = "Оплата услуг"
                break
            case .user:
                type = "Перевод клиенту Binary Bank"
                break
            }
            
            cell.operationType.text = type
            
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Ваша история пуста"
        return cell
        
    }
    
}
