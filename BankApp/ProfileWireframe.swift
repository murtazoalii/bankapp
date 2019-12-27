//
//  ProfileWireframe.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

class ProfileWireframe: Mainframe {
    
    var navController: ProfileRouter!
    let user = UserDefaults.standard.loadObjectWithKey(key: "user") as! User
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestureToScene()
        
        
        self.navigationController?.navigationBar.topItem!.title = user.fullname
        prepareImageViewForRender(imageView: profileImage)

    }
    
    func prepareImageViewForRender(imageView: UIImageView){
        imageView.image = user.img!
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = profileImage.frame.height/2
        imageView.layer.masksToBounds = true
    }


}
