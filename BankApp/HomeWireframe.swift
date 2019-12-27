//
//  TestWireframe.swift
//  BankApp
//
//  Created by Abdurahimov Aliakbar on 06.02.17.
//  Copyright © 2017 Abdurahimov Aliakbar. All rights reserved.
//

import UIKit

extension Notification.Name{
    static let CardsHaveBeenLoadedNotification = Notification.Name("CardsHaveBeenLoadedNotification")
    static let DepositsHaveBeenLoadedNotification = Notification.Name("DepositsHaveBeenLoadedNotification")
}

class HomeWireframe: Mainframe, EventReceiverProtocol {
    
    @IBOutlet weak var tableView: HomeTableView!
    
    lazy public var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Loading data
        let user = UserDefaults.standard.loadObjectWithKey(key: "user") as! User
        HomeTableData.instance.loadCards(id: user.id)
        DepositLoader.instance.uploadDeposit(id: user.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGestureToScene()
        tableView.parent = self
        activityIndicator.frame.origin = CGPoint(x: self.view.frame.width/2 - activityIndicator.frame.width/2, y: self.view.frame.height/2 - activityIndicator.frame.height/2)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    func initSegueFromSubview(data: Any?, segue: SegueID){
        self.performSegue(withIdentifier: segue.rawValue, sender: data)
    }
    
    
}
