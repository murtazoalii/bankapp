//
//  PassCodeView.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit
import SmileLock
import JSSAlertView

class PassCodeWireframe: UIViewController {

    let numberOfDigits = 4
    var passwordContainerView: PasswordContainerView!
    var isInitial: Bool!
    var user: User!
    @IBOutlet weak var externalContainer: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Container View Settings
        passwordContainerView = PasswordContainerView.createWithDigit(numberOfDigits)
        passwordContainerView.frame = externalContainer.bounds
        passwordContainerView.delegate = self
        externalContainer.addSubview(passwordContainerView)
        
        user = UserDefaults.standard.loadObjectWithKey(key: "user") as! User
        
        if user.code != nil{
            isInitial = false
            let name = user.fullname.components(separatedBy: " ")[0]
            welcomeLabel.text = "Здравствуйте, " + name
        }
        else{
            isInitial = true
            welcomeLabel.text = "Придумайте код для авторизации"
        }
        
    }
    
}

//MARK: PasswordInputCompleteProtocol

extension PassCodeWireframe: PasswordInputCompleteProtocol
{
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        
        if isInitial != true {
            if user.code != input
            {
                showAlert(success: false)
                passwordContainerView.clearInput()
                return
            }
            
            performSegueOnThread()
        }
        else{
            showAlert(success: true)
            
            user.code = input
            UserDefaults.standard.saveObject(object: user, key: "user")
        }

    }
    
    func performSegueOnThread(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "mainScreenSegue", sender: self)
        }
    }
    
    //MARK: - Alert Views
    
    func showAlert(success: Bool){
        if success{
            let alertView = JSSAlertView().show(self, title: "Последний штрих", text: "Ваш пароль был успешно сохранен!", noButtons: false, buttonText: "Отлично", cancelButtonText: nil, color: #colorLiteral(red: 0.4334578514, green: 0.7840958238, blue: 0.3812353313, alpha: 1), iconImage: nil, delay: nil, timeLeft: nil)
            
            alertView.addAction(performSegueOnThread)
            alertView.setTextTheme(.light)
        }
        else{
            let alertView = JSSAlertView().show(self, title: "Что-то пошло не так", text: "Вы ввели неверный пароль", noButtons: true, buttonText: nil, cancelButtonText: nil, color: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), iconImage: nil, delay: nil, timeLeft: 1)
            
            alertView.setTextTheme(.light)
        }
    }
    
    //TODO: - touchAuthenticationComplete
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: NSError?) {
        
        if success
        {
            
        }
        else
        {
            passwordContainerView.clearInput()
        }
        
    }
}
