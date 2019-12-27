//
//  AuthWireframe.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit
import JSSAlertView

struct QueryError: OptionSet
{
    let rawValue: Int
    
    static let emailField = QueryError(rawValue: 1 << 0)
    static let passField = QueryError(rawValue: 1 << 1)
}

class AuthWireframe: UIViewController, UserDelegate, ImageSessionDelegate {

    
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    
    var users: [User] = []
    let connection = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserManager.instance.delegate = self
        ImageManager.instance.delegate = self
        
        if checkConnection(){
            if (UserDefaults.standard.loadObjectWithKey(key: "user") != nil)
            {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "passCodeSegue", sender: self)
                }
                
            }
        }
        
    }
    
    func checkConnection() -> Bool{
        if !connection.isReachable{
            DispatchQueue.main.async {
                self.showError(title: "Отсутствует соединение с сетью", text: "К сожалению, вы не подключены к сети")
            }
            return false
        }
        return true
    }
    
    @IBAction func didTouchSignInButton(_ sender: Any) {
        
        if checkConnection(){
            let error: QueryError = catchErrorsBeforeSending(email: emailTextField.text, pass: passwordTextField.text)
            
            if error.isEmpty
            {
                let email = emailTextField.text!
                let password = passwordTextField.text!
                UserManager.instance.getUsers(email: email, password: password)
            }
            else if error.contains(.emailField) || error.contains(.passField)
            {
                showError(title: "Ошибка", text: "Вы не ввели данные!")
            }
        }
    }
    
    
    func catchErrorsBeforeSending(email: String?, pass: String?) -> QueryError
    {
        var temp: QueryError = []
        
        if email == nil || email == ""
        {
            temp.insert(QueryError.emailField)
        }
        
        if pass == nil || pass == ""
        {
            temp.insert(QueryError.passField)
        }
        
        return temp
    }
    
    //MARK: - AlertViews
    
    func showError(title: String, text: String){
        let alertView = JSSAlertView().show(self, title: title, text: text, noButtons: true, buttonText: nil, cancelButtonText: nil, color: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), iconImage: nil, delay: nil, timeLeft: 1)
        alertView.setTextTheme(.light)
    }
    
    
    //MARK: UserDelegate
    
    func usersDownloaded(users: NSArray) {
        if users.count > 0{
            self.users = users as! [User]
            ImageManager.instance.downloadImage(urlString: self.users[0].imgURL!)
        }
        else{
            showError(title: "Ошибка", text: "Вы ввели неверные данные")
        }
    }
    
    //MARK: - ImageSessionDelegate
    
    func imageDidLoad(image: UIImage) {
        if self.users.count > 0{
            let user = self.users[0]
            user.img = image
            UserDefaults.standard.saveObject(object:user, key: "user")
            UserDefaults.standard.synchronize()
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "passCodeSegue", sender: self)
            }
        }
    }
    
    func didFinishWithError(connection: Bool){
        if !connection{
            showError(title: "Ошибка", text: "Отсутствует соединение с сервером!")
        }
    }
    
}
