//
//  DepositContainer.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit
import JSSAlertView

class DepositContainer: UITableViewController, DepositManagerDelegate {
    
    @IBOutlet weak var sumSlider: UISlider!
    @IBOutlet weak var termSlider: UISlider!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    
    @IBAction func sumDidChange(_ sender: Any) {
        let slider = sender as! UISlider
        let value = Int(slider.value) - Int(slider.value) % 1000
        sumLabel.text = "\(value.stringFormat) Р"
    }

    @IBAction func termDidChange(_ sender: Any) {
        let slider = sender as! UISlider
        var value: Float = slider.value
        var text: String
        
        if slider.value < 1{
            value = 12*slider.value
            text = "месяцев"
        }
        else if slider.value >= 1 && slider.value < 2{
            text = "год"
        }
        else{
            text = "года"
        }
        
        
        termLabel.text = "\(Int(value)) \(text)"
    }
    
    
    @IBAction func didTouchButton(_ sender: Any) {
        let sum = Int(sumSlider.value)
        let term = String(termSlider.value)
        let user = UserDefaults.standard.loadObjectWithKey(key: "user") as! User
        DepositManager.instance.uploadDeposit(sum: Int(sum), term: term, ownerId: user.id)
        
    }
    
    func dataHasBeenSent() {
        showAlert(success: true, title: "Отлично", text: "Данные сохранены")
    }
    
    func showAlert(success: Bool, title: String, text: String){
        if success{
            let alertView = JSSAlertView().show(self, title: title, text: text, noButtons: false, buttonText: "Ок", cancelButtonText: nil, color: #colorLiteral(red: 0.4334578514, green: 0.7840958238, blue: 0.3812353313, alpha: 1), iconImage: nil, delay: nil, timeLeft: nil)
            
            alertView.setTextTheme(.light)
        }
        else{
            let alertView = JSSAlertView().show(self, title: title, text: text, noButtons: true, buttonText: nil, cancelButtonText: nil, color: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), iconImage: nil, delay: nil, timeLeft: 1)
            
            alertView.setTextTheme(.light)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        DepositManager.instance.delegate = self
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = #colorLiteral(red: 0.9120810628, green: 0.9349395633, blue: 0.9612939954, alpha: 1)
        header.textLabel?.textColor = UIColor.black.withAlphaComponent(0.5)
        header.textLabel?.frame = header.frame
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

}
