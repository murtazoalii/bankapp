//
//  TransferWireframe.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit
import JSSAlertView

class TransferWireframe: UIViewController, DataReceiver, UITableViewDataSource, UITableViewDelegate, UploadManagerDelegate {

    var data: String?
    var cards: [Card]! = []
    let headerHeight: CGFloat = 35.0
    
    @IBOutlet weak var receiverTextField: UITextField!
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var transferButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "SelfTransferCell", bundle: nil), forCellReuseIdentifier: "SelfTransferCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
        self.cards = UserDefaults.standard.loadObjectWithKey(key: "cards") as! [Card]
        tableView.reloadData()
        
        UploadManager.instance.delegate = self
        
        transferButton.layer.cornerRadius = 8.0
        transferButton.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = data
    }
 
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelfTransferCell", for: indexPath) as! SelfTransferCell
        
        let row = indexPath.row
        let title = cards[row].title
        let number = String(cards[row].info.number)
        let index = number!.index(number!.endIndex, offsetBy: -4)
        let securedNumber = "**** \(number!.substring(from: index))"
        var image: UIImage
        
        
        switch cards[row].info.title{
        case .visa:
            image = #imageLiteral(resourceName: "visa")
        case .mastercard:
            image = #imageLiteral(resourceName: "mastercard")
        case .maestro:
            image = #imageLiteral(resourceName: "maestro")
        }
        
        cell.cardTitle.text = title
        cell.cardNumber.text = securedNumber
        cell.cardImage.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SelfTransferCell
        let section = indexPath.section
        let numberOfRows = self.tableView(tableView, numberOfRowsInSection: section)
        
        cell.containerView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.1980603448)
        cell.backgroundColor = .white
        
        for i in 0..<numberOfRows{
            let ip = IndexPath(row: i, section: section)
            let x = tableView.cellForRow(at: ip) as! SelfTransferCell
            
            if x.isSelected && x !== cell{
                self.tableView.deselectRow(at: ip, animated: false)
                x.containerView.backgroundColor = #colorLiteral(red: 0.9775175452, green: 0.9775403142, blue: 0.9775280356, alpha: 1)
                x.backgroundColor = .white
            }
            
        }
    }
    
    @IBAction func didTouchTransferButton(_ sender: Any) {
        if sumTextField.text != "" && receiverTextField.text != ""{
            if let paths = tableView.indexPathsForSelectedRows{

                let sum = Int(sumTextField.text!)!
                let cardNumber = receiverTextField.text!.components(separatedBy: .whitespaces).joined()

                
                if cards[paths[0].row].balance - sum >= 0{
                    let curDate = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let date = formatter.string(from: curDate)
                    let owner = cards[paths[0].row].id
                    let receiver = 1
                    
                    var bill = ""
                    for _ in 1...12{
                        bill += "\(arc4random_uniform(10))"
                    }
                    
                    UploadManager.instance.uploadData(date: date, sum: sum, bill: bill, receiver: receiver, cardNumber: cardNumber, owner: owner)
                    
                }
                else{
                    showAlert(success: false, title: "Упс", text: "Недостаточно средств")
                }
        
            }
            else{
                showAlert(success: false, title: "Упс", text: "Вы не выбрали ни одной карты")
            }
            
        }
        else{
            showAlert(success: false, title: "Упс", text: "Вы не ввели сумму перевода")
        }

    }

    //MARK: - Alert Views
    
    func showAlert(success: Bool, title: String, text: String){
        if success{
            let alertView = JSSAlertView().show(self, title: title, text: text, noButtons: false, buttonText: "Ок", cancelButtonText: nil, color: #colorLiteral(red: 0.4334578514, green: 0.7840958238, blue: 0.3812353313, alpha: 1), iconImage: nil, delay: nil, timeLeft: nil)
            
            //alertView.addAction(performSegueOnThread)
            alertView.setTextTheme(.light)
        }
        else{
            let alertView = JSSAlertView().show(self, title: title, text: text, noButtons: true, buttonText: nil, cancelButtonText: nil, color: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), iconImage: nil, delay: nil, timeLeft: 1)
            
            alertView.setTextTheme(.light)
        }
    }
    
    func dataHasBeenSent() {
        showAlert(success: true, title: "Отлично", text: "Операция прошла успешно")
    }
    

}
