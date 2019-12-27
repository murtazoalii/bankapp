//
//  SettingsController.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit
import JSSAlertView

class SettingsController: UITableViewController, SettingsManagerDelegate {

    
    @IBOutlet weak var changePassBut: UIButton!
    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var oldPasswordAccepted: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsManager.instance.delegate = self
        changePassBut.layer.cornerRadius = 8.0
        changePassBut.layer.masksToBounds = true
    }

    
    
    @IBAction func didTouchSaveButton(_ sender: Any) {
        
        if oldPassword.text != "" && oldPasswordAccepted.text != "" && newPassword.text != ""{
            let oldPass = oldPassword.text!
            let oldPassAccepted = oldPasswordAccepted.text!
            
            if oldPass == oldPassAccepted{
                
                let user = UserDefaults.standard.loadObjectWithKey(key: "user") as! User
                
                if user.password == oldPass{
                    let newPass = newPassword.text!
                    SettingsManager.instance.uploadData(id: user.id, password: newPass, oldPassword: oldPass)
                }
                else{
                    showAlert(success: false, title: "Ошибка", text: "Неверный пароль")
                }
            }
            else{
                showAlert(success: false, title: "Ошибка", text: "Пароли не совпадают")
            }
        }
        else{
            showAlert(success: false, title: "Ошибка", text: "Вы не ввели необходимые данные")
        }
    }
    
    //MARK: - Alert Views
    
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
    
    func dataHasBeenSent() {
        showAlert(success: true, title: "Отлично", text: "Данные сохранены")
    }
    
}
